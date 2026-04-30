import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:learning_app/core/app_colors.dart';
import 'package:learning_app/core/app_theme.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/route/router.dart';

class DecksPage extends StatelessWidget {
  const DecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decks"),
      ),
      body: Consumer<DeckProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.decks.isEmpty) {
            return _EmptyState(onCreate: () => _showCreateDialog(context));
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              96,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: AppTheme.deckCardAspectRatio,
              crossAxisSpacing: AppTheme.spacingMd,
              mainAxisSpacing: AppTheme.spacingMd,
            ),
            itemCount: provider.decks.length,
            itemBuilder: (_, index) {
              final deck = provider.decks[index];
              return _DeckCard(
                deck: deck,
                colorIndex: index,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text("New deck"),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New deck"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Deck name",
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: "Description (optional)",
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<DeckProvider>().createDeck(
                      nameController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 72,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            "No decks yet",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            "Create your first deck to start learning",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text("Create deck"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Deck card
// ─────────────────────────────────────────────────────────
class _DeckCard extends StatelessWidget {
  final Deck deck;
  final int colorIndex;

  const _DeckCard({
    required this.deck,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = AppColors.deckGradient(colorIndex);
    final accentColor = AppColors.deckColor(colorIndex);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.deckDetail(deck.id)),
      child: Hero(
        tag: 'deck_${deck.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top badge area ──
                Row(
                  children: [
                    // Card count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.credit_card_rounded,
                            size: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${deck.cardCount}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Decorative hanzi accent
                    Text(
                      deck.name.isNotEmpty
                          ? String.fromCharCode(deck.name.runes.first)
                          : '字',
                      style: AppTheme.chineseStyle(
                        size: 32,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ── Deck name ──
                Text(
                  deck.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppTheme.spacingXs),

                // ── Description ──
                if (deck.description != null &&
                    deck.description!.isNotEmpty)
                  Text(
                    deck.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
