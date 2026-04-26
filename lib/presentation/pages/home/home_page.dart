import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/presentation/providers/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Hero avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text("🧙", style: TextStyle(fontSize: 60)),
                  ),
                ),
                const SizedBox(height: 16),

                // Level + name
                Text(
                  "Ученик ${provider.level} уровня",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // XP bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: provider.totalCards > 0
                              ? provider.xp / provider.xpToNextLevel
                              : 0,
                          minHeight: 12,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${provider.xp} / ${provider.xpToNextLevel} XP · Всего карточек: ${provider.totalCards}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Играть button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () => context.push("/game/lobby"),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text("Играть", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
