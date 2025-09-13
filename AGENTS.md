# Repository Guidelines

## Project Structure & Module Organization
- `lib/`: app code — `main.dart`, plus `models/`, `screens/`, `services/`, `theme/`, `utils/`.
- `test/`: Dart/Flutter tests (e.g., `widget_test.dart`).
- Platform folders: `android/`, `linux/`.
- Config: `pubspec.yaml`, `analysis_options.yaml` (lints), `.gitignore`.
- Mobile UI automation: `appium_setup_guide.md`, `appium_test_config.json`, `sample_appium_test.py`.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`
- Run app: `flutter run` (use `-d <device>` for target)
- Analyze code: `flutter analyze`
- Format code: `dart format lib test`
- Unit/widget tests: `flutter test`
- Coverage (optional): `flutter test --coverage` → `coverage/lcov.info`
- Android APK (debug): `flutter build apk --debug`
- Appium tests: start server `appium --port 4723`, then `python -m pytest sample_appium_test.py -v`

## Coding Style & Naming Conventions
- Lints: uses `flutter_lints` via `analysis_options.yaml`; fix all `flutter analyze` issues.
- Indentation: 2 spaces; line length 80–100 chars when practical.
- File names: `snake_case.dart` (e.g., `hotel_list_screen.dart`).
- Types/classes: `UpperCamelCase`; methods/vars: `lowerCamelCase`.
- Widgets: prefer `const` constructors; keep screens under `lib/screens/` and services under `lib/services/`.

## Testing Guidelines
- Framework: `flutter_test` with `testWidgets` and `group`.
- Test files end with `_test.dart` and mirror `lib/` structure.
- Keep tests deterministic; use `pumpWidget` and explicit finders.
- Aim for meaningful coverage of screens and services (target ≥ 80% where feasible).

## Commit & Pull Request Guidelines
- Commit style: Conventional Commits (e.g., `feat: ...`, `refactor: ...`, `fix: ...`).
- PRs should include: clear description, linked issues, screenshots for UI changes, and test steps.
- Ensure `flutter analyze`, `dart format`, and `flutter test` pass before requesting review.

## Security & Configuration Tips
- Do not commit signing keys or secrets; keep Android signing configs local.
- For Appium, prefer semantic labels in widgets to improve element discovery (see guide).

## Agent-Specific Instructions
- Follow these guidelines when editing files in this repo; avoid unrelated refactors.
- Keep changes minimal, scoped, and consistent with existing structure.
