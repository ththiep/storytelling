# Storytelling

Flutter app for child-friendly interactive storytelling.

The app is organized around three story modes:

- **Read**: narrated audio with page images and karaoke word highlighting.
- **Play**: story-native games, starting with a page-order puzzle.
- **Talk**: speaking practice for children, starting with page-by-page read-aloud practice.

## Current Status

| Area | Status |
|---|---|
| Catalog | Available |
| Story hub | Available |
| Read mode | Audio, karaoke text, manual swipe, auto page |
| Play mode | Page-order puzzle |
| Talk mode | v0 practice screen + startup microphone permission |
| Localization | English and Vietnamese |

## Permissions

The app requests microphone permission at startup so Talk can record the
child reading aloud in the next slice.

- Permission service: `lib/core/permissions/app_permission_service.dart`
- Android: `RECORD_AUDIO`
- iOS/macOS: `NSMicrophoneUsageDescription`
- iOS: `PERMISSION_MICROPHONE=1` in `ios/Podfile`

## Run

```bash
flutter pub get
flutter run
```

## Verify

```bash
flutter analyze
flutter test
```

## Docs

- [Project structure](docs/project-structure.md)
- [Product spec](docs/spec/product-spec.md)
- [Brainstorming](docs/brainstorming/interactive-storytelling-brainstorm.md)
