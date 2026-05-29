---
description: "Flutter/Dart coding standards for flutter_proxy"
applyTo: "lib/**/*.dart"
---

- Use Riverpod providers (`@riverpod` annotation), never setState
- Use freezed for all data models — immutable, copyWith, equality
- Use json_serializable for all models that are persisted or transferred
- Validation functions return `Map<String, String>` with field name as key, error message as value
- Never use `print()` — use the `logger` package (`AppLogger.d(...)`, `.i(...)`, `.e(...)`)
- Platform channel method names must match exactly on both Flutter and native side
- Handle `PlatformException` on every platform channel call
- Group imports: dart:, flutter:, packages:, then local — separated by blank lines
