# Navigation

GoRouter is the **only** navigation mechanism. NEVER use `Navigator.of(context).push(MaterialPageRoute(...))`.
All paths must use route constants from `lib/route/router.dart`.

## Bottom Navigation (StatefulShellRoute)

Two tabs, state is preserved when switching:

| Index | Tab | Icon | Path |
|-------|-----|------|------|
| 0 | Home | `home` | `/home` |
| 1 | Decks | `folder` | `/decks` |

No game tab in bottom nav. The game lobby is accessed from the HomePage.

## Route Structure

```
|/home                         → HomePage (tab 0)
|  /home/lobby                 → GameLobbyPage
|/decks                        → DecksPage (tab 1)
|/decks/:id                    → DeckDetailPage
|/decks/:id/add-word           → AddWordPage (create mode)
|/decks/:id/edit-word/:wordId  → AddWordPage (edit mode)
|
|/game/battle/:deckId          → GameBattlePage (full-screen, no bottom nav)
```

## Navigation Flows

### Creating a deck

```
DecksPage → FAB "New deck" → dialog (name + optional description)
```

No separate page — just a dialog.

### Creating a card

```
DecksPage → tap deck → DeckDetailPage → FAB "+" → bottom sheet
  └→ Manual         → /decks/:id/add-word (AddWordPage)
  └→ AI generate    → "Coming soon" SnackBar
  └→ Import         → "Coming soon" SnackBar
```

### Editing a card

```
DeckDetailPage → tap card → /decks/:id/edit-word/:wordId (AddWordPage in edit mode)
```

### Starting a battle

```
HomePage → "Play" button → GameLobbyPage
  └→ Select deck (dropdown) + mode (card selector) → Start Battle!
    └→ /game/battle/:deckId (GameBattlePage, full-screen, no bottom nav)
      └→ Game over → Back to Lobby / Play Again
```

**Note:** GameBattlePage receives the GameMode via `state.extra` in the GoRouter, not through the route path itself. The `deckId` is in the path, and `mode` is in extra.

## AppRoutes (route constants)

Defined in `lib/route/router.dart`:

```dart
class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String decks = '/decks';
  static const String addWord = '/decks/:deckId/add-word';
  static const String editWord = '/decks/:deckId/edit-word/:wordId';
  static const String gameLobby = '/home/lobby';
  static const String gameBattleRoute = '/game/battle/:deckId';

  static String deckDetail(int id) => '/decks/$id';
  static String addWordRoute(int deckId) => '/decks/$deckId/add-word';
  static String editWordRoute(int deckId, int wordId) =>
      '/decks/$deckId/edit-word/$wordId';
  static String gameBattle(int deckId) => '/game/battle/$deckId';
}
```

**Route constants vs route builders:** Always use AppRoutes constants in `GoRoute(builder: ...)` as well. The constant `AppRoutes.gameBattleRoute` should be used as the `path:` parameter, not a hardcoded string.

### GoRoute registration

```dart
// ✅ CORRECT
GoRoute(
  path: AppRoutes.gameBattleRoute,  // uses constant
  builder: (context, state) { ... }
)

// ❌ WRONG — hardcoded string
GoRoute(
  path: '/game/battle/:deckId',     // hardcoded!
  builder: (context, state) { ... }
)
```

## Navigation Types

| Action | Method | When |
|--------|--------|------|
| Switch tab | `navigationShell.goBranch(index)` | Bottom nav switching |
| Open on top | `context.push(route)` | Details, forms |
| Replace | `context.go(route)` | Redirects, stack reset |
| Back | `context.pop()` | Return to previous screen |
| With result | `await context.push<bool>(route)` | Get true/false back |

### Examples

```dart
// Push (open on top)
context.push(AppRoutes.addWordRoute(deckId));

// Push with result
final saved = await context.push<bool>(AppRoutes.addWordRoute(deckId));

// Push with data (extra)
context.push(AppRoutes.gameBattle(deckId), extra: {'mode': selectedMode});

// Push with data (extra) — reading it back in builder
final extra = state.extra as Map? ?? {};
final mode = extra['mode'] as GameMode? ?? GameMode.translationToWord;

// Replace (redirect)
context.go(AppRoutes.home);

// Back
context.pop();
context.pop(true); // with result
```

## Content Creation

### Card form (AddWordPage)

Fields when creating or editing a card:

| Field | Required | Description |
|-------|----------|-------------|
| Word (character) | ✅ | Chinese character(s) |
| Pinyin | | Transcription |
| Translation | ✅ | English translation |
| Sentence context | | Example sentence |
| Notes | | User's personal notes |
| Source | | Where the word came from |

Create and edit share the same `AddWordPage` (edit-mode via `editCard` parameter).

### AI generation (future)

- User enters a topic ("food", "travel")
- External API generates 10-20 cards (word + pinyin + translation + example)
- Architecture: Flutter → Go backend → LLM

### Import from text (future)

- User pastes text (article, dialogue)
- App splits into words, suggests adding as cards
- Future: CSV / Anki import

## Rules

- ALL paths through route constants, never hardcoded strings
- ALL GoRoute `path:` parameters use AppRoutes constants, not hardcoded strings
- Error screen registered in GoRouter
- Parametrized routes through pathParameters or extra
- NEVER `Navigator.push` / `Navigator.pop` (except `showDialog` which has its own navigator)
- No dead routes — every registered route must have a working handler
- Pages should not have dead action buttons (e.g., "/settings" with no handler)
