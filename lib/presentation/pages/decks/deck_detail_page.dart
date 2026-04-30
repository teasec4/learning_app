import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:learning_app/core/app_colors.dart';
import 'package:learning_app/core/app_theme.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/route/router.dart';

int _colorIndexForDeck(Deck deck) {
  if (deck.name.isEmpty) return 0;
  return deck.name.codeUnitAt(0) % AppColors.deckColors.length;
}

class DeckDetailPage extends StatefulWidget {
  final int deckId;

  const DeckDetailPage({
    super.key,
    required this.deckId,
  });

  @override
  State<DeckDetailPage> createState() => _DeckDetailPageState();
}

class _DeckDetailPageState extends State<DeckDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordCardProvider>().loadCards(widget.deckId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final deck =
        deckProvider.decks.where((d) => d.id == widget.deckId).firstOrNull;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with deck gradient ──
          _DeckHeader(deck: deck),

          // ── Card list ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              AppTheme.spacingLg,
              96,
            ),
            sliver: _CardList(
              deckId: widget.deckId,
              deck: deck,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCardSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add card",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: const Text("Manual"),
                  subtitle: const Text("Enter word, pinyin, translation"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(AppRoutes.addWordRoute(widget.deckId));
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  title: const Text("AI generate"),
                  subtitle: const Text("Generate cards from a topic"),
                  trailing: _SoonBadge(),
                  enabled: false,
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      Icons.file_upload_outlined,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  title: const Text("Import from text"),
                  subtitle: const Text("Parse text into word cards"),
                  trailing: _SoonBadge(),
                  enabled: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, Deck? deck) {
    if (deck == null) return;
    final controller = TextEditingController(text: deck.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rename"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "New name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<DeckProvider>()
                    .renameDeck(deck.id, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text("Rename"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDeckDialog(
      BuildContext context, int? deckId, String? deckName) {
    if (deckId == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete deck?"),
        content: Text("All cards in \u00ab$deckName\u00bb will be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              context.read<DeckProvider>().deleteDeck(deckId);
              Navigator.pop(ctx);
              // ignore: deprecated_member_use
              if (context.mounted) context.pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Deck header — SliverAppBar with gradient
// ─────────────────────────────────────────────────────────
class _DeckHeader extends StatelessWidget {
  final Deck? deck;
  const _DeckHeader({this.deck});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final d = deck;
    if (d == null) {
      return SliverAppBar(
        title: const Text("Deck"),
        pinned: true,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(
                  value: 'delete', child: Text('Delete deck')),
            ],
          ),
        ],
      );
    }

    final colorIndex = _colorIndexForDeck(d);
    final gradientColors = AppColors.deckGradient(colorIndex);
    final accentColor = AppColors.deckColor(colorIndex);

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // We need to find the state — this is hacky for a short demo
            // Better: use a callback. But for now we access via context.
            if (value == 'rename') {
              // find the nearest parent state
              final state = context.findAncestorStateOfType<_DeckDetailPageState>();
              state?._showRenameDialog(context, deck);
            } else if (value == 'delete') {
              final state = context.findAncestorStateOfType<_DeckDetailPageState>();
              state?._showDeleteDeckDialog(context, d.id, d.name);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'rename',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Rename'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Delete deck', style: TextStyle(color: Colors.red)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingLg,
            kToolbarHeight + 24,
            AppTheme.spacingLg,
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              if (d.description != null &&
                  d.description!.isNotEmpty)
                Text(
                  d.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const Spacer(),
              // Stats row
              Row(
                children: [
                  Icon(
                    Icons.credit_card_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${d.cardCount} cards",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Card list (with empty state)
// ─────────────────────────────────────────────────────────
class _CardList extends StatelessWidget {
  final int deckId;
  final Deck? deck;

  const _CardList({
    required this.deckId,
    this.deck,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WordCardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final cards = provider.cards;
        if (cards.isEmpty) {
          return SliverFillRemaining(
            child: _EmptyDeck(deckId: deckId),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final card = cards[index];
              return _WordCardItem(
                cardId: card.id,
                deckId: deckId,
                word: card.word,
                pinyin: card.pinyin,
                translation: card.translation,
              );
            },
            childCount: cards.length,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty deck state
// ─────────────────────────────────────────────────────────
class _EmptyDeck extends StatelessWidget {
  final int deckId;
  const _EmptyDeck({required this.deckId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_rounded,
            size: 64,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            "No cards yet",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            "Add your first word to this deck",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),
          FilledButton.tonalIcon(
            onPressed: () {
              context.push(AppRoutes.addWordRoute(deckId));
            },
            icon: const Icon(Icons.add),
            label: const Text("Add card"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Single word card item
// ─────────────────────────────────────────────────────────
class _WordCardItem extends StatelessWidget {
  final int cardId;
  final int deckId;
  final String word;
  final String? pinyin;
  final String translation;

  const _WordCardItem({
    required this.cardId,
    required this.deckId,
    required this.word,
    this.pinyin,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Dismissible(
        key: ValueKey(cardId),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppTheme.spacingXl),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Icon(
            Icons.delete_rounded,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        onDismissed: (_) {
          context.read<WordCardProvider>().deleteCard(cardId, deckId);
        },
        child: Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            onTap: () async {
              await context.push<bool>(
                AppRoutes.editWordRoute(deckId, cardId),
                extra: {'editCard': null},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                children: [
                  // Word column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word,
                          style: AppTheme.chineseStyle(
                            size: 20,
                            weight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        if (pinyin != null && pinyin!.isNotEmpty)
                          Text(
                            pinyin!,
                            style: AppTheme.pinyinStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          translation,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// "Soon" badge widget
// ─────────────────────────────────────────────────────────
class _SoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "soon",
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}
