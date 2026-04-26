import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/presentation/pages/home/home_page.dart';
import 'package:learning_app/presentation/pages/decks/decks_page.dart';
import 'package:learning_app/presentation/pages/game/game_page.dart';
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/game",
                builder: (context, state) => const GamePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
