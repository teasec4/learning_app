import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/presentation/pages/decks/add_word_page.dart';
import 'package:learning_app/domain/entities/deck.dart';

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
    final deck = deckProvider.decks.where((d) => d.id == widget.deckId).firstOrNull;
    final deckName = deck?.name ?? "Колода";

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
              const PopupMenuItem(value: 'rename', child: Text('Переименовать')),
              const PopupMenuItem(value: 'delete', child: Text('Удалить деку')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => AddWordPage(deckId: widget.deckId),
            ),
          );
          if (result == true && mounted) {
            context.read<DeckProvider>().refreshCardCounts();
          }
        },
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
                    "В этой колоде пока нет карточек",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => AddWordPage(deckId: widget.deckId),
                        ),
                      );
                      if (result == true && mounted) {
                        context.read<DeckProvider>().refreshCardCounts();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Добавить карточку"),
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
                  context.read<WordCardProvider>().deleteCard(card.id, widget.deckId);
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
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => AddWordPage(
                          deckId: widget.deckId,
                          editCard: card,
                        ),
                      ),
                    );
                    if (result == true && mounted) {
                      context.read<DeckProvider>().refreshCardCounts();
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

  void _showRenameDialog(BuildContext context, Deck? deck) {
    if (deck == null) return;
    final controller = TextEditingController(text: deck.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Переименовать"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Новое название"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Отмена"),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<DeckProvider>().renameDeck(deck.id, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text("Переименовать"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDeckDialog(BuildContext context, int? deckId, String? deckName) {
    if (deckId == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Удалить деку?"),
        content: Text("Все карточки в «$deckName» будут удалены."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Отмена"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              context.read<DeckProvider>().deleteDeck(deckId);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Удалить"),
          ),
        ],
      ),
    );
  }
}
