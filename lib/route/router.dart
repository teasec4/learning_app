import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/presentation/pages/home/home_page.dart';
import 'package:learning_app/presentation/pages/decks/decks_page.dart';
import 'package:learning_app/presentation/pages/decks/deck_detail_page.dart';
import 'package:learning_app/presentation/pages/game/game_lobby_page.dart';
import 'package:learning_app/presentation/widgets/bottom_navigation_bar.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/home",
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/home",
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/decks",
                builder: (context, state) => const DecksPage(),
                routes: [
                  GoRoute(
                    path: ":id",
                    builder: (context, state) => DeckDetailPage(
                      deckId: int.parse(state.pathParameters["id"]!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/game/lobby",
        builder: (context, state) => const GameLobbyPage(),
      ),
    ],
  );
}
