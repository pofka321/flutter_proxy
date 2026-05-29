---
description: "Implement a new feature in flutter_proxy. Triggers the full plan → code → test loop."
mode: agent
argument-hint: "Describe the feature to implement (e.g. 'proxy profile CRUD', 'network change detection')"
---

Implement the following feature in flutter_proxy: $input

## Before writing any code
1. Read `lib/` to understand the current structure
2. Read `.github/copilot-instructions.md` for project rules
3. List every file you will create or modify, and why

## Implementation order
1. Data model (freezed + json_serializable) — if new model needed
2. Repository / persistence layer
3. Riverpod provider(s)
4. Platform channel stub — if native interaction needed (Flutter side first, native side second)
5. UI (functional only, no polish)
6. Unit tests for model and provider logic

## Constraints
- Follow all rules in `.github/instructions/flutter.instructions.md`
- Follow platform rules in `android-native.instructions.md` or `ios-native.instructions.md` if touching native code
- No credentials in plain text
- No print() calls

## Done when
- `flutter analyze` passes with no errors
- `flutter test` passes
- Feature works end-to-end in a brief description you provide
