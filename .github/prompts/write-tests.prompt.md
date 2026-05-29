---
description: "Write or complete unit tests for a class or feature in flutter_proxy."
mode: agent
argument-hint: "Name the file or class to test (e.g. 'ProxyProfile model', 'proxy_repository.dart')"
---

Write unit tests for: $input

## Before writing tests
1. Read the target file fully
2. Identify all public methods and edge cases
3. Check if tests already exist in `test/` — do not duplicate

## Test requirements
- Use `flutter_test` and `mocktail` for mocks
- One `group()` per class, one `test()` per scenario
- Cover: happy path, empty/null input, invalid input, error states
- For Riverpod providers: use `ProviderContainer` in tests, not widget tests
- For platform channels: mock the `MethodChannel` using `TestDefaultBinaryMessengerBinding`

## File placement
- Mirror the `lib/` path under `test/` (e.g. `lib/features/proxy/proxy_profile.dart` → `test/features/proxy/proxy_profile_test.dart`)

## Done when
- `flutter test <file>` passes with no errors
- All edge cases from the checklist above are covered
