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
│   │   └── utils/word_timing_utils.dart  # page/word index + StoryPlayback
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
│       │   ├── data/
│       │   │   ├── dto/story_dto.dart
│       │   │   ├── mock/mock_story_data.dart
│       │   │   ├── remote/story_api_service.dart
│       │   │   ├── story_repository.dart
│       │   │   └── api_story_repository.dart
│       │   └── presentation/
│       │       ├── home_screen.dart      # Grid 2 cột, title ghim
│       │       └── bloc/                 # StoryListBloc
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
│       └── play/
│           └── presentation/
│               ├── story_game_screen.dart
│               └── widgets/page_order_puzzle_game.dart
│
├── test/
│   ├── story_dto_test.dart
│   ├── story_list_bloc_test.dart
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
│  features/catalog/data · core/audio/permissions · app/theme │
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
| **Core** | `lib/core/` | Network, audio, permissions, timing utils |
| **Shared** | `lib/shared/` | Domain models + reusable widgets |
| **Features** | `lib/features/<name>/` | Vertical slices: data / application / presentation |

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

### Reading

- `StoryReaderBloc` — load, play/pause, page change, completion, listen again
- Reader UI — image above karaoke; companion chrome via `AppAssets`

### Play

- `StoryGameScreen` + `PageOrderPuzzleGame` (tap + drag)

### Talk

- `StoryTalkScreen` — v0 speaking practice.
- Shows one story page at a time with image + large read-aloud text.
- Child taps the mic button to start/stop a practice turn.
- v0 records practice progress in memory only.
- Microphone permission is requested at app startup through `AppPermissionService`.
- ASR, recording playback, and scoring are next slices.

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
| Talk | 🚧 | v0 practice screen + mic permission, no recorder/ASR/scoring yet |
| Monetization | ❌ | Not started |

---

## 8. Where to add new code

| Adding… | Put it in… |
|---|---|
| Catalog / list UI or BLoC | `features/catalog/` |
| Hub UI | `features/hub/presentation/` |
| Reader / completion | `features/reading/` |
| New mini-game | `features/play/presentation/widgets/` |
| Talk / speaking practice | `features/talk/` |
| Shared widget | `shared/widgets/` |
| Domain model | `shared/models/` |
| Theme / UI asset path | `app/theme/` + `assets/ui/` |
| Audio / network / permissions | `core/` |
| New story package | `assets/stories/<slug>/` (cover, `pages/`, audio) + mock/API |
| Product requirements | `docs/spec/product-spec.md` |

---

## 9. Suggested next steps

1. Complete per-story packages (pages + timed text + audio) instead of reusing `thanh-giong`.
2. Add real microphone capture and parent playback to Talk v1.
3. Split large UI files (`page_order_puzzle_game.dart`, reader screen) into smaller presentation widgets as they grow.
4. Mirror `test/` under feature paths when coverage expands.

---

## Related docs

- [Product Spec](./spec/product-spec.md)
- [Brainstorming](./brainstorming/interactive-storytelling-brainstorm.md)
