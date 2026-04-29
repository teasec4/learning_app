import 'package:learning_app/presentation/pages/home/home_page.dart';
import 'package:learning_app/presentation/pages/decks/decks_page.dart';
import 'package:learning_app/presentation/pages/decks/deck_detail_page.dart';
import 'package:learning_app/presentation/pages/game/game_lobby_page.dart';
import 'package:learning_app/presentation/pages/game/game_battle_page.dart';
import 'package:learning_app/presentation/pages/decks/add_word_page.dart';
import 'package:learning_app/presentation/widgets/bottom_navigation_bar.dart';
import 'package:learning_app/domain/entities/game_mode.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(
        child: Text("Page not found: ${state.uri}"),
      ),
    ),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          );
        },
        branches: [
          // ── Home tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'lobby',
                    builder: (context, state) => const GameLobbyPage(),
                  ),
                ],
              ),
            ],
          ),
          // ── Decks tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.decks,
                builder: (context, state) => const DecksPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => DeckDetailPage(
                      deckId: int.parse(state.pathParameters['id']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'add-word',
                        builder: (context, state) => AddWordPage(
                          deckId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      GoRoute(
                        path: 'edit-word/:wordId',
                        builder: (context, state) {
                          final deckId = int.parse(state.pathParameters['id']!);
                          // TODO: pass editCard via extra when implementing
                          return AddWordPage(deckId: deckId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // ── Full-screen routes (no bottom nav) ──
      GoRoute(
        path: AppRoutes.gameBattleRoute,
        builder: (context, state) {
          final deckId = int.parse(state.pathParameters['deckId']!);
          final extra = state.extra as Map? ?? {};
          final mode = extra['mode'] as GameMode? ?? GameMode.translationToWord;
          return GameBattlePage(deckId: deckId, mode: mode);
        },
      ),
    ],
  );
}
