# Project Structure

> Last updated: 2026-07-15  
> Flutter app: interactive storytelling (Reading / Play / Speaking)

---

## 1. Repository layout

```text
storytelling/
├── lib/                          # Application source code
│   ├── main.dart                 # App entry, MaterialApp, global BLoC providers
│   │
│   ├── bloc/                     # BLoC state management
│   │   ├── story_list/           # Home story catalog
│   │   └── story_reader/         # Reading session (pages, audio, completion)
│   │
│   ├── core/                     # Cross-cutting infrastructure
│   │   ├── config/               # API config (base URL, flags)
│   │   └── network/              # Dio client, API exceptions
│   │
│   ├── data/                     # Data layer
│   │   ├── dto/                  # JSON DTOs + mapping to domain models
│   │   ├── mock/                 # Local mock stories for dev / tests
│   │   ├── remote/               # REST API service (Dio)
│   │   ├── api_story_repository.dart
│   │   └── story_repository.dart # Repository interface + mock impl
│   │
│   ├── di/                       # Dependency injection (get_it)
│   │   └── injection_container.dart
│   │
│   ├── models/                   # Domain models
│   │   └── story.dart            # StoryDetail, StoryPage, StoryLine, StoryWord…
│   │
│   ├── screens/                  # Full-screen UI flows
│   │   ├── home_screen.dart              # Story list
│   │   ├── story_hub_screen.dart         # 3 modes: Reading / Play / Speaking
│   │   ├── story_reader_screen.dart      # Reading + karaoke
│   │   ├── story_completion_screen.dart  # Post-reading celebration
│   │   └── story_game_screen.dart        # Play mode shell
│   │
│   ├── services/                 # Platform / media services
│   │   ├── audio_engine.dart     # just_audio playback + timeline events
│   │   └── narration_engine.dart # Narration event types
│   │
│   ├── theme/                    # Design system
│   │   ├── app_colors.dart       # Raw color palette
│   │   ├── app_typography.dart   # Text styles
│   │   ├── storytelling_theme.dart # ThemeExtension tokens
│   │   └── theme_manager.dart    # ThemeData builder + context.storyTheme
│   │
│   ├── utils/                    # Pure helpers
│   │   └── word_timing_utils.dart # Page/word index from audio position
│   │
│   └── widgets/                  # Reusable UI components
│       ├── karaoke_text.dart
│       ├── story_image.dart
│       └── games/
│           └── page_order_puzzle_game.dart
│
├── test/                         # Unit & widget tests
│   ├── story_dto_test.dart
│   ├── story_list_bloc_test.dart
│   ├── word_timing_utils_test.dart
│   ├── page_order_puzzle_game_test.dart
│   └── widget_test.dart
│
├── assets/                       # Bundled story media
│   └── stories/
│       └── too-big/              # Mock story id: 8
│           ├── audio.m4a
│           ├── cover.png
│           ├── page_1.png … page_3.png
│           └── text.txt
│
├── docs/                         # Product & engineering docs
│   ├── spec/
│   │   └── product-spec.md
│   ├── brainstorming/
│   │   └── interactive-storytelling-brainstorm.md
│   └── project-structure.md      # This file
│
├── android/ ios/ macos/ linux/ windows/ web/   # Platform runners
├── pubspec.yaml                  # Dependencies & asset manifest
└── README.md
```

---

## 2. Architecture layers

```text
┌─────────────────────────────────────────────────────────┐
│  Screens / Widgets                                      │
│  home → hub → reader | game | (speaking TBD)            │
└───────────────────────────┬─────────────────────────────┘
                            │ context.read<Bloc>()
┌───────────────────────────▼─────────────────────────────┐
│  BLoC                                                   │
│  StoryListBloc · StoryReaderBloc                        │
└───────────────────────────┬─────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ StoryRepository│   │ AudioEngine   │   │ ThemeManager  │
│ (mock / API)   │   │ (just_audio)  │   │ (design tokens)│
└───────┬───────┘   └───────────────┘   └───────────────┘
        │
        ▼
┌───────────────┐
│ StoryApiService│──► Dio ──► REST backend (optional)
│ MockStoryData  │──► assets/stories/
└───────────────┘
```

| Layer | Responsibility |
|---|---|
| **Screens** | Navigation, layout, user actions |
| **BLoC** | Business logic, async flows, UI state |
| **Repository** | Fetch `StoryDetail`; hide mock vs API |
| **DTO** | Parse API JSON (`snake_case`) → domain models |
| **Services** | Audio playback, timeline progress events |
| **Theme** | Colors, typography, gradients via `context.storyTheme` |
| **Widgets** | Shared UI + game components |

---

## 3. Navigation flow (current)

```text
HomeScreen (story list)
    └── StoryHubScreen
            ├── Reading  → StoryReaderScreen
            │                 └── StoryCompletionView (on finish)
            │                       ├── Listen again
            │                       └── Play → StoryGameScreen
            ├── Play     → StoryGameScreen
            │                 └── PageOrderPuzzleGame
            └── Speaking → (not implemented)
```

---

## 4. Key modules

### `lib/models/story.dart`

Domain model aligned with API:

- `StoryDetail` — metadata, voices, pages
- `StoryPage` — `imageUrl`, karaoke lines, page timing
- `StoryLine` / `StoryWord` — text + `startTimeMs` / `endTimeMs`
- `StoryVoice` — audio URL + duration

### `lib/bloc/story_reader/`

| File | Role |
|---|---|
| `story_reader_bloc.dart` | Load story, play/pause, page change, completion |
| `story_reader_state.dart` | `Ready`, `Completed`, `Loading`, `Failure` |
| `story_reader_event.dart` | User + audio timeline events |

### `lib/services/audio_engine.dart`

- Plays story audio (asset or network)
- Emits `NarrationTimelineProgress` for karaoke sync
- Fires `NarrationCompleted` → reader completion state

### `lib/theme/`

Centralized design tokens. Use in widgets:

```dart
final theme = context.storyTheme;
Text('Title', style: theme.screenTitle);
```

### `lib/di/injection_container.dart`

Registers via `get_it`:

- `StoryRepository` (mock by default; `useRemoteApi: true` for API)
- `StoryListBloc`, `StoryReaderBloc` (factory)
- `AudioEngine` (factory per reader session)

---

## 5. Data sources

| Source | When | Entry |
|---|---|---|
| **Mock** | Default dev / tests | `MockStoryRepository` → `mock_story_data.dart` |
| **REST API** | `configureDependencies(useRemoteApi: true)` | `ApiStoryRepository` → `StoryApiService` |
| **Assets** | Story media | `assets/stories/<slug>/` declared in `pubspec.yaml` |

---

## 6. Tests

| Test file | Covers |
|---|---|
| `story_dto_test.dart` | API JSON parsing |
| `word_timing_utils_test.dart` | Karaoke page/word index |
| `story_list_bloc_test.dart` | Catalog loading |
| `page_order_puzzle_game_test.dart` | Puzzle piece model |
| `widget_test.dart` | Home list + hub navigation |

Run: `flutter test`

---

## 7. Implementation status by folder

| Area | Status | Notes |
|---|---|---|
| `screens/home_screen.dart` | ✅ | Story list |
| `screens/story_hub_screen.dart` | ✅ | 3-mode entry; Speaking disabled |
| `screens/story_reader_screen.dart` | ✅ | Karaoke; page images not shown yet |
| `screens/story_completion_screen.dart` | ✅ | Listen again + Play |
| `screens/story_game_screen.dart` | ✅ | Page-order puzzle |
| `widgets/games/` | ⚠️ | v1 puzzle only; no multi-round chunking |
| `theme/` | ✅ | ThemeManager wired; some screens not migrated |
| Speaking screens | ❌ | Not started |
| Monetization / IAP | ❌ | Not started |

---

## 8. Where to add new code

| Adding… | Put it in… |
|---|---|
| New screen | `lib/screens/` |
| New mini-game | `lib/widgets/games/` |
| New BLoC | `lib/bloc/<feature>/` |
| API field / model | `lib/data/dto/` + `lib/models/` |
| Color / text style | `lib/theme/` |
| Shared widget | `lib/widgets/` |
| Story assets | `assets/stories/<slug>/` + `pubspec.yaml` |
| Product requirements | `docs/spec/product-spec.md` |

---

## Related docs

- [Product Spec](./spec/product-spec.md)
- [Brainstorming](./brainstorming/interactive-storytelling-brainstorm.md)
