import CoreLocation
import Flutter
import NetworkExtension
import UIKit

class SettingsChannel {
  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "SettingsChannel") else { return }
    let messenger = registrar.messenger()
    let channel = FlutterMethodChannel(
      name: "com.pofka321.flutter_proxy/system_settings",
      binaryMessenger: messenger
    )

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "openWifiSettings":
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
          result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
          return
        }

        DispatchQueue.main.async {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { _ in }
            result(nil)
          } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
          }
        }

      case "getWifiSsid":
        if #available(iOS 14.0, *) {
          NEHotspotNetwork.fetchCurrent { network in
            result(network?.ssid)
          }
        } else {
          result(nil)
        }

      case "requestWifiSsidPermissions":
        LocationPermissionRequester.request(flutterResult: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

private class LocationPermissionRequester: NSObject, CLLocationManagerDelegate {
  private static var pendingResults: [FlutterResult] = []
  private static var locationManager: CLLocationManager?
  private static var instance: LocationPermissionRequester?

  static func request(flutterResult: @escaping FlutterResult) {
    DispatchQueue.main.async {
      let status = CLLocationManager.authorizationStatus()
      switch status {
      case .authorizedWhenInUse, .authorizedAlways:
        flutterResult(true)
      case .denied, .restricted:
        flutterResult(false)
      case .notDetermined:
        pendingResults.append(flutterResult)
        if locationManager == nil {
          let mgr = CLLocationManager()
          let inst = LocationPermissionRequester()
          mgr.delegate = inst
          locationManager = mgr
          instance = inst
          mgr.requestWhenInUseAuthorization()
        }
      @unknown default:
        flutterResult(false)
      }
    }
  }

  func locationManager(
    _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
  ) {
    guard status != .notDetermined else { return }
    let granted = status == .authorizedWhenInUse || status == .authorizedAlways
    let callbacks = LocationPermissionRequester.pendingResults
    LocationPermissionRequester.pendingResults.removeAll()
    LocationPermissionRequester.locationManager = nil
    LocationPermissionRequester.instance = nil
    callbacks.forEach { $0(granted) }
  }
}
