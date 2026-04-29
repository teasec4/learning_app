# Roadmap

## ✅ Done

- Clean Architecture structure (domain → data → presentation)
- CRUD for Deck, WordCard, GameSession (Isar Community)
- HomePage with placeholder level/XP display
- DeckDetailPage (card list, swipe-to-delete, rename, bottom sheet for card creation)
- AddWordPage (create/edit form, English UI)
- GoRouter with BottomNavigation (2 tabs: Home, Decks)
- AppServices DI container
- Navigation fully on GoRouter (no Navigator.push)
- GameType — only `duel` (all old modes removed)
- Route constants + Error screen in router.dart
- DecksPage — card-stack visual + FAB "New deck" (dialog)
- DeckDetailPage — bottom sheet (Manual / AI / Import) for card creation
- Dead code removed: CreatePage, SettingsPage, unused GameSessionProvider in main
- Hardcoded routes replaced with AppRoutes constants
- English-only spec (conventions.md + content-creation.md removed, merged into architecture.md / navigation.md)
- **Game Engine (MVP):**
  - GameViewModel — Hearthstone-like engine (hand, HP, damage, timer, speed bonus)
  - GameState + GamePhase + GameMode entities
  - GameBattlePage — battle UI (HP bars, question, player hand, timer, result screen)
  - GameMode.translationToWord — first mode implemented
  - Linear speed bonus damage (1-3 HP, faster = more damage)
  - GameSession saved after battle (create on start, update on end)
  - Empty deck detection + early game over if no cards
  - Race condition guards: phase-based guards + `_disposed` check in all callbacks
  - GameLobbyPage — English UI, deck + mode selector, wired to battle
  - Route `/game/battle/:deckId` with GoRouter (mode via extra)
  - **Step-by-step phase animation:** aiTurn → playerTurn → resultShown
  - AI turn: 1.5s reveal animation with "AI's turn..." spinner label
  - Phase-specific UI indicators in _QuestionArea (aiTurn/playerTurn/resultShown labels)
  - Structured timer: only runs during playerTurn, guarded against stale callbacks
  - All `Future.delayed` transitions guarded by phase checks

## 🔜 Next

- [ ] AI card generation via external API (bottom sheet → active)
- [ ] Import cards from text (bottom sheet → active)
- [ ] Per-card statistics (correct/incorrect over time)
- [ ] UserProfile — avatar, level, XP, statistics
- [ ] Achievements
- [ ] Possible migration Provider → Bloc
- [ ] Customization (themes, avatars)
- [ ] Additional game modes: word→translation, cloze

## ✅ Spec Audit Issues — All Resolved

All code-spec discrepancies found during audit have been fixed:

| # | Issue | Status |
|---|-------|--------|
| 1 | HomePage had Russian text | → Translated to English |
| 2 | Hardcoded `/settings` route on HomePage & DecksPage | → Removed |
| 3 | Hardcoded `'/game/battle/:deckId'` in router.dart GoRoute `path:` | → Uses `AppRoutes.gameBattleRoute` |
| 4 | Hardcoded `'/decks/:deckId/add-word'` and `'/decks/:deckId/edit-word/:wordId'` in router.dart | → Uses `AppRoutes.addWord` / `AppRoutes.editWord` |
| 5 | New word cards overwrite each other (id=0 upsert in WordCardRepositoryImpl._toModel) | → Guard added: only set model.id if card.id != 0 |
| 6 | GameSessionRepositoryImpl._toModel same id=0 issue (redundant DB records on every game start) | → Guard added: only set model.id if session.id != 0 |
