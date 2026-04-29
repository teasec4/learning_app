# Hanzi Battle (learning_app)

> Learn Chinese characters through gamified Hearthstone-like battles against AI.

## Goal

Turn Chinese character memorization into an engaging card battle game.
Users build decks of words, then duel an AI opponent — correct answers deal damage,
wrong ones hurt you.

## Target Platform

iOS and Android (MVP). No desktop, no web.

## Stack

Flutter + Clean Architecture + GoRouter + Provider + Isar Community

## Spec Docs

| File | Covers |
|------|--------|
| [architecture.md](architecture.md) | Clean Architecture layers, DI / AppServices, state management, naming conventions, pre-commit checklist |
| [domain-model.md](domain-model.md) | Entities: Deck, WordCard, GameSession, GameState, repositories |
| [navigation.md](navigation.md) | GoRouter routes, bottom nav, page flows, content creation (manual / AI / import) |
| [game-engine.md](game-engine.md) | Hearthstone-like battle mechanics, game state, AI opponent, data flow |
| [roadmap.md](roadmap.md) | Done, next, future, known issues |

## Known Code Issues

See [roadmap.md](roadmap.md) → "Issues found during spec audit" section.
