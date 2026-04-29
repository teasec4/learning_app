import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/domain/entities/word_card.dart';

class AddWordPage extends StatefulWidget {
  final int deckId;
  final WordCard? editCard;

  const AddWordPage({super.key, this.deckId = 0, this.editCard});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _pinyinController = TextEditingController();
  final _translationController = TextEditingController();
  final _contextController = TextEditingController();
  final _notesController = TextEditingController();
  final _sourceController = TextEditingController();
  bool _saving = false;
  bool get _isEditing => widget.editCard != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final c = widget.editCard!;
      _wordController.text = c.word;
      _pinyinController.text = c.pinyin ?? '';
      _translationController.text = c.translation;
      _contextController.text = c.contextSentence ?? '';
      _notesController.text = c.notes ?? '';
      _sourceController.text = c.source ?? '';
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _pinyinController.dispose();
    _translationController.dispose();
    _contextController.dispose();
    _notesController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit card" : "New word"),
        actions: [
          TextButton(
            onPressed: _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? "Update" : "Save"),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: "Word (character) *",
                hintText: "学习",
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pinyinController,
              decoration: const InputDecoration(
                labelText: "Пиньинь",
                hintText: "xuéxí",
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _translationController,
              decoration: const InputDecoration(
                labelText: "Translation *",
                hintText: "учить(ся), изучать",
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contextController,
              decoration: const InputDecoration(
                labelText: "Sentence context",
                hintText: "我在学习中文。",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Optional section
            Text("Optional",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                )),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes",
                hintText: "E.g. often confused with ...",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: "Source",
                hintText: "Textbook, Weibo, drama ...",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final provider = context.read<WordCardProvider>();
      final word = _wordController.text.trim();
      final pinyin = _pinyinController.text.trim().isEmpty
          ? null
          : _pinyinController.text.trim();
      final translation = _translationController.text.trim();
      final contextSentence = _contextController.text.trim().isEmpty
          ? null
          : _contextController.text.trim();
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      final source = _sourceController.text.trim().isEmpty
          ? null
          : _sourceController.text.trim();

      if (_isEditing) {
        final c = widget.editCard!;
        await provider.updateCard(
          WordCard(
            id: c.id,
            deckId: c.deckId,
            word: word,
            pinyin: pinyin,
            translation: translation,
            contextSentence: contextSentence,
            notes: notes,
            source: source,
            createdAt: c.createdAt,
          ),
        );
      } else {
        await provider.addCard(
          deckId: widget.deckId,
          word: word,
          pinyin: pinyin,
          translation: translation,
          contextSentence: contextSentence,
          notes: notes,
          source: source,
        );
      }

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
}
