import Flutter
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
      guard call.method == "openWifiSettings" else {
        result(FlutterMethodNotImplemented)
        return
      }

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
    }
  }
}
