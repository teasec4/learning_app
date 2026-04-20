import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/presentation/pages/game/game_page.dart';
import 'package:learning_app/presentation/pages/space/space_page.dart';
import 'package:learning_app/presentation/widgets/bottom_navigation_bar.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/game",
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (contex, state, navigationShell) {
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
              GoRoute(path: "/game", builder: (context, state) => GamePage()),
            ],
          ),
          
          StatefulShellBranch(
            routes: [
              GoRoute(path: "/space", builder: (context, state) => SpacePage()),
            ],
          ),
        ],
      ),
    ],
  );
}
