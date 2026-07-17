# Project Structure

> Last updated: 2026-07-17  
> Flutter app: interactive storytelling (Read / Play / Talk)  
> Layout: **feature-first** (`app` / `core` / `shared` / `features`)

---

## 1. Repository layout

```text
storytelling/
├── lib/
│   ├── main.dart
│   │
│   ├── app/                              # App shell
│   │   ├── storytelling_app.dart         # MaterialApp + StoryListBloc provider
│   │   ├── di/injection_container.dart   # get_it
│   │   └── theme/
│   │       ├── app_assets.dart
│   │       ├── app_colors.dart
│   │       ├── app_typography.dart
│   │       ├── storytelling_theme.dart
│   │       └── theme_manager.dart
│   │
│   ├── core/                             # Cross-cutting infrastructure
│   │   ├── config/api_config.dart
│   │   ├── network/                      # Dio, ApiException
│   │   ├── permissions/
│   │   │   └── app_permission_service.dart # microphone permission
│   │   ├── audio/
│   │   │   ├── audio_engine.dart         # just_audio + timeline
│   │   │   └── narration_events.dart     # NarrationEvent types
│   │   ├── recording/
│   │   │   └── story_voice_recording_service.dart # record + playback
│   │   └── utils/word_timing_utils.dart  # page/word index + StoryPlayback
│   │
│   ├── l10n/                             # Generated + ARB localizations
│   │   ├── app_en.arb
│   │   ├── app_vi.arb
│   │   ├── app_localizations.dart
│   │   ├── app_localizations_en.dart
│   │   └── app_localizations_vi.dart
│   │
│   ├── shared/
│   │   ├── models/story.dart             # Domain models
│   │   └── widgets/                      # Cross-feature UI
│   │       ├── karaoke_text.dart
│   │       ├── story_image.dart
│   │       ├── story_back_button.dart
│   │       ├── story_scaffold_background.dart
│   │       └── stroke_text.dart
│   │
│   └── features/
│       ├── catalog/
│       │   ├── application/              # StoryListBloc + events/states
│       │   ├── data/
│       │   │   ├── dto/story_dto.dart
│       │   │   ├── mock/mock_story_data.dart
│       │   │   ├── remote/story_api_service.dart
│       │   │   ├── story_repository.dart
│       │   │   └── api_story_repository.dart
│       │   └── presentation/
│       │       └── home_screen.dart      # Grid 2 cột, title ghim
│       │
│       ├── hub/
│       │   └── presentation/story_hub_screen.dart
│       │
│       ├── reading/
│       │   ├── application/              # StoryReaderBloc + events/states
│       │   └── presentation/
│       │       ├── story_reader_screen.dart
│       │       └── story_completion_screen.dart
│       │
│       ├── play/
│       │   └── presentation/
│       │       ├── story_game_screen.dart
│       │       └── widgets/page_order_puzzle_game.dart
│       │
│       └── talk/
│           ├── application/              # StoryTalkBloc + events/states
│           └── presentation/story_talk_screen.dart
│
├── test/
│   ├── story_dto_test.dart
│   ├── story_list_bloc_test.dart
│   ├── story_reader_bloc_test.dart
│   ├── word_timing_utils_test.dart
│   ├── page_order_puzzle_game_test.dart
│   └── widget_test.dart
│
├── assets/
│   ├── stories/
│   │   ├── thanh-giong/                  # Full demo package
│   │   │   ├── cover.jpg
│   │   │   ├── audio.m4a
│   │   │   └── pages/page_1.jpeg … page_3.png
│   │   ├── de-men-phieu-luu-ky/cover.jpeg
│   │   ├── cay-khe/cover.jpg
│   │   ├── hoa-tan/cover.jpeg
│   │   ├── ai-han-mieu-thanh-huong/cover.jpeg
│   │   └── huyet-sac/cover.jpeg
│   └── ui/
│       ├── backgrounds/story_background.png
│       └── icons/                        # play/pause/back/heart/… + congratulation.gif
│
├── docs/
│   ├── spec/product-spec.md
│   ├── brainstorming/interactive-storytelling-brainstorm.md
│   └── project-structure.md
│
├── android/ ios/ macos/ linux/ windows/ web/
├── pubspec.yaml
└── README.md
```

---

## 2. Architecture layers

```text
┌──────────────────────────────────────────────────────────┐
│  features/*/presentation (+ application BLoCs where needed) │
│  catalog → hub → reading | play | talk                   │
└────────────────────────────┬─────────────────────────────┘
                             │
┌────────────────────────────▼─────────────────────────────┐
│  features/catalog/data · core/audio/recording/permissions · app/theme │
└────────────────────────────┬─────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              ▼                             ▼
     MockStoryRepository            StoryApiService → Dio
              │
              ▼
     assets/stories/<slug>/
```

| Layer | Location | Responsibility |
|---|---|---|
| **App shell** | `lib/app/` | DI, theme, `MaterialApp` |
| **Core** | `lib/core/` | Network, audio, recording, permissions, timing utils |
| **Shared** | `lib/shared/` | Domain models + reusable widgets |
| **Localization** | `lib/l10n/` | ARB source + generated `AppLocalizations` |
| **Features** | `lib/features/<name>/` | Vertical slices: data / application / presentation |

### Feature-first + BLoC convention

Each feature owns its main flow and state:

```text
features/<feature>/
  application/
    <feature>_bloc.dart
    <feature>_event.dart
    <feature>_state.dart
  data/            # only when the feature owns data access
  presentation/
    *_screen.dart
    widgets/
```

Rules:

- Each feature should have one primary BLoC when it owns non-trivial user flow or async state.
- A complex screen inside a feature may add its own smaller BLoC under the same `application/` folder.
- Presentation widgets render state and dispatch events; business flow, recording/audio state, loading, and errors live in BLoC.
- Tiny widget-only interaction can stay local when it is isolated and disposable. Current example: `PageOrderPuzzleGame` keeps local drag/drop state until Play gains multi-round game flow.
- Shared platform services stay in `core/`; shared models/widgets stay in `shared/`.
- App strings go through `AppLocalizations`; add copy in both `app_en.arb` and `app_vi.arb`, then run `flutter gen-l10n`.

---

## 3. Navigation flow

```text
HomeScreen (catalog)
  · pinned "Góc kể chuyện"
  · 2-column cover grid (+ favorite heart)
    └── StoryHubScreen
            ├── Reading → StoryReaderScreen
            │               · page image + KaraokeText
            │               └── StoryCompletionView
            │                     · cover + congratulation GIF
            │                     · listen again / play
            ├── Play → StoryGameScreen → PageOrderPuzzleGame
            └── Talk → StoryTalkScreen
```

---

## 4. Story packages (`assets/stories/`)

| Slug folder | Title | Package contents |
|---|---|---|
| `thanh-giong/` | Thánh Gióng | cover + pages + audio |
| `de-men-phieu-luu-ky/` | Dế Mèn phiêu lưu ký | cover only |
| `cay-khe/` | Cây Khế | cover only |
| `hoa-tan/` | Hoa Tàn | cover only |
| `ai-han-mieu-thanh-huong/` | Ái hận miêu thành hương | cover only |
| `huyet-sac/` | Huyết Sắc | cover only |

**Prototype note:** catalog entries without their own pages/audio temporarily reuse `thanh-giong` pages + audio in `mock_story_data.dart`.

`pubspec.yaml` registers each story folder (and `thanh-giong/pages/`) plus `assets/ui/...`.

---

## 5. Key modules

### Catalog data

- `StoryRepository` / `MockStoryRepository` / `ApiStoryRepository`
- `StoryDetailDto` → `StoryDetail`
- `mock_story_data.dart` — 6 catalog stories
- `StoryListBloc` — catalog loading and refresh

### Reading

- `StoryReaderBloc` — load, play/pause, page change, completion, listen again
- Reader UI — image above karaoke; companion chrome via `AppAssets`

### Play

- `StoryGameScreen` + `PageOrderPuzzleGame` (tap + drag)
- Play does not yet have a feature-level BLoC because the current puzzle is a single local widget interaction. Add `features/play/application/StoryGameBloc` when implementing rounds, scoring, or persisted game progress.

### Talk

- `StoryTalkBloc` — page navigation, recording state, playback, completion notices
- `StoryTalkScreen` — v0 speaking practice.
- Shows one story page at a time with image + large read-aloud text.
- Child taps the mic button to start/stop a practice turn.
- Records one reusable `latest.m4a` per story page through `StoryVoiceRecordingService`.
- Shows a listen-again control when a page already has a recording.
- Microphone permission is requested at app startup through `AppPermissionService`.
- ASR, scoring, parent review, and recording history are next slices.

### Recording

- `StoryVoiceRecordingService` wraps `record`, `path_provider`, and `just_audio`.
- Files are stored under app documents:
  `recordings/story_<storyId>/page_<pageNumber>/latest.m4a`.
- New recordings first write to `recording.m4a`, then replace `latest.m4a` after a successful stop.
- Playback uses the existing local file path with `just_audio`.

### Permissions

- `AppPermissionService` wraps `permission_handler` so UI/features do not call permission APIs directly.
- `main.dart` requests microphone permission after DI is configured and before `runApp`.
- Android declares `android.permission.RECORD_AUDIO`.
- iOS/macOS declare `NSMicrophoneUsageDescription`.
- iOS `Podfile` enables `PERMISSION_MICROPHONE=1`.
- macOS entitlements include `com.apple.security.device.audio-input`.

### Theme

```dart
final theme = context.storyTheme;
Image.asset(AppAssets.playButton);
```

### Localization

- `l10n.yaml` configures Flutter localization generation.
- Source files: `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`.
- Generated files are checked in under `lib/l10n/`.
- `StorytellingApp` wires `AppLocalizations.delegate`, Flutter global delegates, and `supportedLocales`.
- Current supported locales: `en`, `vi`.

---

## 6. Tests

| File | Covers |
|---|---|
| `story_dto_test.dart` | DTO parsing |
| `word_timing_utils_test.dart` | Karaoke indexes |
| `story_list_bloc_test.dart` | Catalog load (6 stories) |
| `story_reader_bloc_test.dart` | Reader audio/page behavior |
| `page_order_puzzle_game_test.dart` | Puzzle piece model |
| `widget_test.dart` | Home + hub navigation |

```bash
flutter test
```

---

## 7. Implementation status

| Area | Status | Notes |
|---|---|---|
| Catalog home grid | ✅ | Feature `catalog` |
| Story hub | ✅ | Feature `hub` |
| Reading + karaoke + page image | ✅ | Feature `reading` |
| Completion celebration | ✅ | Cover + GIF overlay |
| Play puzzle | ⚠️ | No multi-round chunking yet |
| Per-story full packages | ⚠️ | Only `thanh-giong` complete |
| Microphone permission | ✅ | Requested on startup through `AppPermissionService` |
| Talk | 🚧 | Record + listen again, no ASR/scoring/history yet |
| Monetization | ❌ | Not started |

---

## 8. Where to add new code

| Adding… | Put it in… |
|---|---|
| Feature BLoC/event/state | `features/<feature>/application/` |
| Feature screen/widget | `features/<feature>/presentation/` |
| Feature-owned data/API | `features/<feature>/data/` |
| Catalog / list UI or BLoC | `features/catalog/` |
| Hub UI | `features/hub/presentation/` |
| Reader / completion | `features/reading/` |
| New mini-game | `features/play/presentation/widgets/` |
| Talk / speaking practice | `features/talk/` |
| Shared widget | `shared/widgets/` |
| Domain model | `shared/models/` |
| Theme / UI asset path | `app/theme/` + `assets/ui/` |
| Audio / network / recording / permissions | `core/` |
| Localized copy | `lib/l10n/app_en.arb` + `lib/l10n/app_vi.arb` |
| New story package | `assets/stories/<slug>/` (cover, `pages/`, audio) + mock/API |
| Product requirements | `docs/spec/product-spec.md` |

---

## 9. Suggested next steps

1. Complete per-story packages (pages + timed text + audio) instead of reusing `thanh-giong`.
2. Add parent review, deletion controls, and optional ASR/scoring to Talk v1.
3. Split large UI files (`page_order_puzzle_game.dart`, reader screen) into smaller presentation widgets as they grow.
4. Mirror `test/` under feature paths when coverage expands.

---

## Related docs

- [Product Spec](./spec/product-spec.md)
- [Brainstorming](./brainstorming/interactive-storytelling-brainstorm.md)
