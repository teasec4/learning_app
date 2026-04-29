import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
        // settings removed — no SettingsPage exists
      ),
      body: Consumer<DeckProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.decks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    "No decks yet",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text("Create deck"),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.decks.length,
            itemBuilder: (_, index) {
              final deck = provider.decks[index];
              return _DeckCardStack(deck: deck);
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
            const SizedBox(height: 12),
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

class _DeckCardStack extends StatelessWidget {
  final Deck deck;

  const _DeckCardStack({required this.deck});

  static const double _offset = 4;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.deckDetail(deck.id)),
      child: Stack(
        children: [
          // Card layer 2 (bottom)
          Positioned(
            bottom: _offset,
            right: _offset,
            child: _cardLayer(
              color: colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          // Card layer 1 (middle)
          Positioned(
            bottom: _offset * 0.5,
            right: _offset * 0.5,
            child: _cardLayer(
              color: colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          // Card layer 0 (top — main)
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Decorative card pattern
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.style,
                        size: 48,
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deck.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${deck.cardCount} cards",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardLayer({required Color color}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}
