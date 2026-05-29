---
description: "iOS native coding standards for flutter_proxy NetworkExtension code"
applyTo: "ios/**/*.swift"
---

- Packet Tunnel Provider logic lives in a separate app extension target (`ProxyTunnelExtension`)
- Never put network routing logic in the main app target
- Use `NEPacketTunnelProvider` — override `startTunnel`, `stopTunnel`, `handleAppMessage`
- Communicate between main app and extension via `NETunnelProviderSession` messages
- All entitlements (`com.apple.developer.networking.networkextension`) must be in the extension target, not the main app
- Use `NSLog` or `os_log` with subsystem `"com.pofka321.flutter_proxy"` for logging
- Define shared channel constants in `ChannelConstants.swift` (mirrored from Android)
