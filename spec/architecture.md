# Architecture

## Clean Architecture Layers

```
lib/
├── core/              # shared: colors, theme, constants
├── domain/
│   ├── entities/      # business entities (Deck, WordCard, GameSession, GameState, GameMode)
│   └── repositories/  # abstract repository interfaces
├── data/
│   ├── datasources/   # DatabaseService (Isar Community)
│   ├── models/        # Isar models (with @collection annotations)
│   └── repositories/  # repository implementations (Entity ↔ Model)
├── presentation/
│   ├── providers/     # ChangeNotifier providers (DeckProvider, HomeProvider, WordCardProvider)
│   ├── view_models/   # GameViewModel (game engine logic, ChangeNotifier)
│   ├── pages/         # screens (home, decks, game)
│   └── widgets/       # shared widgets (bottom nav, reusable components)
├── route/             # GoRouter configuration (router.dart)
├── service/           # AppServices — singleton DI container
└── main.dart          # entry point
```

## Dependency Rules

| Layer | Depends On |
|-------|-----------|
| Presentation → | Domain (via Provider or AppServices) |
| Data → | Domain (via abstract Repository interfaces) |
| Domain | Nothing (pure Dart, no Flutter dependency) |
| Core | Nothing |
| Route | Presentation/pages |

## DI / AppServices

`AppServices` is the single source of truth for dependency injection.

- Singleton, initialized once in `main()`
- Owns database initialization and repository creation
- Providers receive repositories through AppServices
- ViewModels (like GameViewModel) access AppServices directly via the singleton

```dart
// ❌ WRONG — manual instantiation
final repo = DeckRepositoryImpl(database);

// ✅ CORRECT — through AppServices
final repo = appServices.deckRepository;

// ✅ CORRECT — through Provider (inside widget tree)
final repo = context.read<DeckProvider>();
```

**Rules:**
- NEVER create repositories/services manually — always go through AppServices
- Services should be stateless or properly managed
- Dispose services at app shutdown if needed
- Close streams / cancel subscriptions in dispose()

### Cleanup / Lifecycle

- Dispose controllers (TextEditingController, AnimationController) in `dispose()`
- Cancel StreamController / StreamSubscription in `dispose()`
- ChangeNotifier providers self-clean when disposed
- GameViewModel manages its own Timer lifecycle (cancelled in dispose())
- ViewModels created via ChangeNotifierProvider inside a StatefulWidget's build are scoped to that page

## State Management

**Provider** is sufficient for current complexity. No complex cross-state dependencies.

| Tool | Where |
|------|-------|
| `ChangeNotifier` | Business logic providers (DeckProvider) + GameViewModel |
| `setState()` | UI-only state (animations, visibility, scroll position, selected tab) |
| `Consumer<T>` / `context.watch<T>()` | Reactive subscriptions |
| `context.read<T>()` | One-shot calls (onPressed, initState) |
| `Selector<T, S>` | Granular subscription to a slice of state (avoids full rebuilds) |

### setState vs ChangeNotifier

```dart
// ❌ BAD: business data through setState
setState(() { _isSaving = true; });
await provider.saveCard(card);
setState(() { _isSaving = false; });

// ✅ GOOD: UI-only state (panel visibility) — setState
setState(() { _isExpanded = !_isExpanded; });

// ✅ Business state (loading, data) — Provider
context.read<DeckProvider>().saveDeck(name);
// UI listens via context.watch<DeckProvider>().isLoading
```

### Providers registered in main.dart

| Provider | Type | Description |
|----------|------|-------------|
| DeckProvider | ChangeNotifierProvider | CRUD for decks |
| HomeProvider | ChangeNotifierProvider | Level/XP display |
| WordCardProvider | ChangeNotifierProvider | CRUD for word cards |

GameViewModel is **not** registered globally — created inline in GameBattlePage via `ChangeNotifierProvider(create: (_) => GameViewModel())`.

## Naming Conventions

| What | Pattern | Example |
|------|---------|---------|
| Providers | `XxxProvider` | `DeckProvider` |
| ViewModels | `XxxViewModel` | `GameViewModel` |
| Services | `XxxService` | `DatabaseService` |
| Pages | `XxxPage` | `HomePage` |
| Widgets | `XxxWidget` | `AppBottomNavigationBar` |
| Repository (abstract) | `XxxRepository` | `DeckRepository` |
| Repository (impl) | `XxxRepositoryImpl` | `DeckRepositoryImpl` |

## Code Conventions

### Async Safety

```dart
// ALWAYS check mounted after await before using context
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<WordCardProvider>().loadCards(widget.deckId);
  });
}
```

- `mounted` check after `await` before using context
- `try-catch` on all async operations
- `initState` → `addPostFrameCallback` for provider calls

### UI

- `const` constructors wherever possible
- Small reusable widgets (< 300 lines)
- No widget > 300 lines
- Material 3 + design system (app_colors, app_theme)
- Responsive layout (test on different screen sizes)
- Avoid unnecessary rebuilds — extract widgets, use const
- Use `Selector<T, S>` for granular subscriptions
- **UI language: English only** (Chinese characters for vocabulary content)

### Navigation

- All navigation through GoRouter only
- Route constants in `lib/route/router.dart` (see [navigation.md](navigation.md))
- NEVER use `Navigator.of(context).push(MaterialPageRoute(...))`
- NEVER hardcode path strings in GoRoute builders — use AppRoutes constants
- Error screen registered in GoRouter

### Repositories

- Repositories always accessed through AppServices (singleton)
- ViewModels may access AppServices directly (GameViewModel pattern)
- NEVER instantiate repository implementations manually

### Quality Gates

- `flutter analyze` must pass before commit
- No hardcoded values where constants exist
- `dispose()` for all controllers, streams, subscriptions, timers
- No direct API calls from UI
- No dead routes (every route must have a handler)

---

## Pre-commit Checklist

### Code Quality
- [ ] No hardcoded values (strings, colors, magic numbers)
- [ ] Follows naming conventions
- [ ] AppServices used correctly
- [ ] No direct API calls from UI
- [ ] UI is English (except vocabulary content)

### Navigation
- [ ] GoRouter only, not Navigator.push
- [ ] No hardcoded route strings (only route constants from AppRoutes)
- [ ] No dead code routes (SettingsPage, CreatePage, etc.)

### Safety
- [ ] `mounted` check after `await`
- [ ] `try-catch` for all async operations
- [ ] `dispose()` for controllers and timers

### UI
- [ ] Responsive layout
- [ ] Uses design system (theme, colors)
- [ ] Widgets < 300 lines
- [ ] `const` constructors used

### Performance
- [ ] No unnecessary rebuilds
- [ ] Selectors used where beneficial

### Validation
- [ ] `flutter analyze` — clean
- [ ] No runtime errors
- [ ] Feature works end-to-end
