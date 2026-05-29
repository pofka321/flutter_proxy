package com.pofka321.flutter_proxy

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class SettingsChannel {
    companion object {
        private const val CHANNEL = "com.pofka321.flutter_proxy/system_settings"

        fun register(activity: Activity, flutterEngine: FlutterEngine) {
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
                        else -> result.notImplemented()
                    }
                }
        }
    }
}
