import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:learning_app/core/app_colors.dart';
import 'package:learning_app/core/app_theme.dart';
import 'package:learning_app/presentation/providers/home_provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/route/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hanzi Battle"),
      ),
      body: Consumer2<HomeProvider, DeckProvider>(
        builder: (context, home, decks, _) {
          final theme = Theme.of(context);

          // ── Loading state ──
          if (home.isLoading || (decks.isLoading && decks.decks.isEmpty)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Text(
                    'Loading your stats...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          final cardsTotal = home.totalCards;
          final decksTotal = decks.decks.length;
          final level = home.level;
          final xp = home.xp;
          final xpToNext = home.xpToNextLevel;
          final progress = home.xpToNextLevel > 0 ? home.xpInLevel / home.xpToNextLevel : 0.0;

          return ListView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            children: [
              // ── Profile Card ──
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "🧙",
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Level title
                      Text(
                        "Level $level Apprentice",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      // XP Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "XP",
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "$xp / $xpToNext",
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: theme
                                  .colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // ── Stats Grid ──
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.credit_card_rounded,
                      label: "Cards",
                      value: "$cardsTotal",
                      color: AppColors.deckColor(0), // emerald
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.folder_rounded,
                      label: "Decks",
                      value: "$decksTotal",
                      color: AppColors.deckColor(1), // sky
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.sports_esports_rounded,
                      label: "Games",
                      value: "${home.totalGames}",
                      color: AppColors.deckColor(2), // violet
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // ── Quick Actions ──
              Text(
                "Quick actions",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Play button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.gameLobby),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    "Play",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Browse decks
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Switch to Decks tab (index 1)
                    StatefulNavigationShell.of(context).goBranch(1);
                  },
                  icon: const Icon(Icons.folder_open_rounded),
                  label: const Text("Browse decks"),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // ── Recent Decks ──
              if (decksTotal > 0) ...[
                Text(
                  "Recent decks",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                ...decks.decks.take(3).map(
                      (deck) => _RecentDeckTile(
                        name: deck.name,
                        cardCount: deck.cardCount,
                        onTap: () =>
                            context.push(AppRoutes.deckDetail(deck.id)),
                      ),
                    ),
              ],

              const SizedBox(height: AppTheme.spacingXl),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// StatCard
// ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Recent Deck Tile
// ─────────────────────────────────────────────────────────
class _RecentDeckTile extends StatelessWidget {
  final String name;
  final int cardCount;
  final VoidCallback onTap;

  const _RecentDeckTile({
    required this.name,
    required this.cardCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(
              Icons.collections_bookmark_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "$cardCount cards",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
