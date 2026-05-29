package com.pofka321.flutter_proxy

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.net.wifi.WifiManager
import android.provider.Settings
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class SettingsChannel {
    companion object {
        private const val CHANNEL = "com.pofka321.flutter_proxy/system_settings"
        private const val TAG = "SettingsChannel"

        fun register(activity: Activity, flutterEngine: FlutterEngine) {
            val componentActivity = activity as? ComponentActivity
            val pendingPermissionResults = mutableListOf<MethodChannel.Result>()
            val permissionLauncher: ActivityResultLauncher<Array<String>>? =
                componentActivity?.registerForActivityResult(
                    ActivityResultContracts.RequestMultiplePermissions(),
                ) { grants ->
                    val granted = requiredPermissions().all { permission ->
                        grants[permission] == true || hasPermission(activity, permission)
                    }
                    Log.d(TAG, "Permission request finished. granted=$granted grants=$grants")
                    pendingPermissionResults.forEach { pendingResult ->
                        pendingResult.success(granted)
                    }
                    pendingPermissionResults.clear()
                }

            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "openWifiSettings" -> {
                            try {
                                activity.startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
                                result.success(null)
                            } catch (e: ActivityNotFoundException) {
                                result.error("UNAVAILABLE", "Cannot open WiFi settings", null)
                            }
                        }
                        "requestWifiSsidPermissions" -> {
                            val permissions = requiredPermissions()
                            val alreadyGranted = permissions.all { permission ->
                                hasPermission(activity, permission)
                            }
                            if (alreadyGranted) {
                                result.success(true)
                            } else if (permissionLauncher == null) {
                                result.error(
                                    "UNAVAILABLE",
                                    "Cannot request permissions from this Activity",
                                    null,
                                )
                            } else {
                                val shouldLaunchRequest = pendingPermissionResults.isEmpty()
                                pendingPermissionResults.add(result)
                                if (shouldLaunchRequest) {
                                    permissionLauncher.launch(permissions)
                                }
                            }
                        }
                        "getWifiSsid" -> {
                            val missingPermissions = requiredPermissions().filterNot { permission ->
                                hasPermission(activity, permission)
                            }
                            if (missingPermissions.isNotEmpty()) {
                                result.error(
                                    "PERMISSION_DENIED",
                                    "Missing permissions: ${missingPermissions.joinToString()}",
                                    null,
                                )
                                return@setMethodCallHandler
                            }

                            if (!isLocationEnabled(activity)) {
                                Log.d(TAG, "Location services are disabled; SSID may be unavailable")
                            }

                            val wifiManager = activity.applicationContext
                                .getSystemService(Context.WIFI_SERVICE) as WifiManager
                            @Suppress("DEPRECATION")
                            val rawSsid = wifiManager.connectionInfo?.ssid
                            Log.d(TAG, "Raw SSID value: $rawSsid")
                            if (rawSsid == null || rawSsid == "<unknown ssid>" || rawSsid.isEmpty()) {
                                result.success(null)
                            } else {
                                val ssid = rawSsid.removeSurrounding("\"")
                                if (ssid.isEmpty()) result.success(null) else result.success(ssid)
                            }
                        }
                        else -> result.notImplemented()
                    }
                }
        }

        private fun requiredPermissions(): Array<String> {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                arrayOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.NEARBY_WIFI_DEVICES,
                )
            } else {
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
            }
        }

        private fun hasPermission(activity: Activity, permission: String): Boolean {
            return ContextCompat.checkSelfPermission(
                activity,
                permission,
            ) == PackageManager.PERMISSION_GRANTED
        }

        private fun isLocationEnabled(activity: Activity): Boolean {
            val locationManager = activity.getSystemService(Context.LOCATION_SERVICE) as? LocationManager
            if (locationManager == null) return false

            return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        }
    }
}
