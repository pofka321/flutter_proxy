# Flutter Proxy Project — Copilot Instructions

## Core Rule
Never implement features, refactor code, or make structural changes without explicit direction from the user. When asked about a feature, propose and explain first — then wait for confirmation before writing any code.

## Project Context
- Flutter app targeting Android and iOS
- Purpose: manage WiFi proxy settings via system VPN profiles
- iOS: NEVPNManager / Network Extension (Swift platform channel)
- Android: VpnService API (Kotlin platform channel)
- SDK: Dart ^3.12.0

## Code Conventions
- Dart: follow `flutter_lints` rules in analysis_options.yaml
- Feature folders under `lib/features/` (already established)
- Platform channel code lives in `android/app/src/main/kotlin/` and `ios/Runner/`
- Ask before adding any new dependency to pubspec.yaml

## Agent Workflow
- Architect proposes before Implementer codes
- Native agents (iOS/Android) own their platform folders exclusively
- QA writes tests before or alongside implementation, never after a feature is "done"
- Device Runner verifies on simulator after each feature
