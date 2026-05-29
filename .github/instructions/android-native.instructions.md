---
description: "Android native coding standards for flutter_proxy VpnService code"
applyTo: "android/**/*.{kt,java}"
---

- All VPN routing logic lives in a class that extends `VpnService`
- Always request VPN permission via `VpnService.prepare()` before starting
- Protect the VPN tunnel socket with `VpnService.protect()` to avoid routing loops
- Use `ConnectivityManager` callbacks to detect network changes; restart tunnel on change
- Log with Android `Log.d/i/e` using tag `"FlutterProxy"`
- Handle `MethodChannel` calls on the main thread; offload network ops to coroutines
- Define all method channel names as constants in a shared `ChannelConstants.kt` file
