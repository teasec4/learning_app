import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/presentation/pages/game/game_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (contex, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/",
                builder: (context, state) => GamePage(),
                
              )
            ]
          )
        ]
      ),
    ],
  );
}
