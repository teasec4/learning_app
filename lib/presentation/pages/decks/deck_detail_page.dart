import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/route/router.dart';

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
    final deckName = deck?.name ?? "Deck";

    return Scaffold(
      appBar: AppBar(
        title: Text(deckName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'rename') {
                _showRenameDialog(context, deck);
              } else if (value == 'delete') {
                _showDeleteDeckDialog(context, deck?.id, deck?.name);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(value: 'delete', child: Text('Delete deck')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCardSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<WordCardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = provider.cards;
          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No cards in this deck yet",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () => _showAddCardSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text("Add card"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Dismissible(
                key: ValueKey(card.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context
                      .read<WordCardProvider>()
                      .deleteCard(card.id, widget.deckId);
                },
                child: ListTile(
                  title: Text(
                    card.word,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans SC',
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "${card.pinyin}\n${card.translation}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                  final result = await context.push<bool>(
                    AppRoutes.editWordRoute(widget.deckId, card.id),
                    extra: {'editCard': card},
                  );
                    if (result == true && mounted) {
                      // Card count auto-syncs via Isar stream in DeckProvider
                    }
                  },
                ),
              );
            },
          );
        },
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add card",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  title: const Text("AI generate"),
                  subtitle: const Text("Generate cards from a topic"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
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
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon!")),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.file_upload_outlined,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  title: const Text("Import from text"),
                  subtitle: const Text("Parse text into word cards"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
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
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon!")),
                    );
                  },
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
        content: Text("All cards in «$deckName» will be deleted."),
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
