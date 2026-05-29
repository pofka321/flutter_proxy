---
name: mobile-ui-tests-parallel
description: 'Run Flutter UI and integration tests on connected Android and iOS devices in parallel. Use when you need side-by-side platform validation, real phone test runs, device-specific failure isolation, or quick checks after UI changes.'
argument-hint: 'Describe which tests to run and which devices to target'
user-invocable: true
---

# Mobile UI Tests In Parallel

Run Flutter widget or integration-style UI tests against Android and iOS targets at the same time, then report each platform result separately.

## When to Use
- You want to run `integration_test` suites on a connected Android phone and iPhone in parallel.
- You need separate Android and iOS outcomes instead of one combined run.
- You want to compare platform-specific failures for the same UI flow.
- You are validating a Flutter UI change on real devices before wrapping up work.

## Procedure
1. Confirm connected devices first.
   - Use `flutter devices`.
   - For Android details, use `adb devices -l`.
   - For iOS details, use `xcrun xctrace list devices` if needed.
2. Choose the exact targets.
   - Android example device id: `RFCTA024KPX`
   - iOS example device id: `00008110-00123452019A801E`
3. Prefer device-backed integration tests for mobile UI validation.
   - Use `flutter test integration_test -d <device-id>`.
   - Run Android and iOS in parallel with separate terminal executions.
4. Use long sync timeouts for device runs.
   - Builds and installs on iOS can take several minutes.
   - Keep each platform in its own command so failures are isolated.
5. Summarize results by platform.
   - Report pass/fail counts separately.
   - Call out environment issues such as signing, VM service connection failures, permission prompts, or device trust problems.

## Parallel Execution Pattern
Use parallel tool execution when both runs are independent.

Android command:
```sh
flutter test integration_test -d RFCTA024KPX
```

iOS command:
```sh
flutter test integration_test -d 00008110-00123452019A801E
```

If running a narrower suite, target explicit files instead of the whole directory.

Android narrow example:
```sh
flutter test integration_test/wifi_ssid_prefill_test.dart -d RFCTA024KPX
```

iOS narrow example:
```sh
flutter test integration_test/wifi_ssid_prefill_test.dart -d 00008110-00123452019A801E
```

## Result Interpretation
- Android pass with iOS failure usually points to iOS signing, launch, or VM service attach issues.
- `Connection refused` or VM service discovery failures on iOS usually mean the test app launched but the Dart VM service did not become reachable in time.
- Platform exceptions printed during tests may still be acceptable if the test expectation allows fallback behavior, but they should be called out.

## Reporting Template
- Android: passed or failed, include the failing test name if any.
- iOS: passed or failed, include build, signing, launch, or VM service issues if any.
- Notes: include warnings that are not test failures but may matter later.

## Repo Notes
- This project already uses `integration_test/` for mobile UI coverage.
- Real-device Android SSID checks may depend on runtime permissions and location services.
- iOS device runs may require valid signing and a stable cable connection.
