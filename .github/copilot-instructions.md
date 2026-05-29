# flutter_proxy — AI Guidelines

## Project Purpose
Flutter app that manages network proxy settings for Android and iOS.
Users save proxy profiles (host, port, type, auth) and the app auto-applies routing when the network changes.

## Architecture
- Flutter UI layer communicates with native Android/iOS via platform channels
- Android: VpnService for traffic routing
- iOS: NetworkExtension (Packet Tunnel Provider)
- State management: Riverpod
- Credential storage: flutter_secure_storage
- Profile storage: shared_preferences or Hive
- Models: freezed + json_serializable

## Coding Rules
- Never store proxy credentials in plain text
- All platform channel calls must handle MethodException
- Network-sensitive code must have unit tests
- Use `logger` package — never use print()
- One feature at a time — no bundling unrelated changes
- Riverpod providers only — no setState in business logic
- Validation returns Map<String, String> field-level errors

## Platform Constraints
- Android: VpnService requires BIND_VPN_SERVICE permission and user consent dialog
- iOS: NetworkExtension requires entitlements; must be a separate app extension target
- Both: Cannot change system-level proxy without VPN tunnel approach

## Build & Test Commands
- `flutter test` — all unit and widget tests
- `flutter build apk --debug` — Android debug build
- `flutter build ios --debug --no-codesign` — iOS debug build (simulator)
- `flutter analyze` — lint check
