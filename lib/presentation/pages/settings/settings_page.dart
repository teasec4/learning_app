import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки")),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _SectionHeader(title: "Интерфейс"),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Язык"),
            subtitle: const Text("Русский"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⬜ Выбор языка — заглушка")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Тема"),
            subtitle: const Text("Системная"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⬜ Тема — заглушка")),
              );
            },
          ),
          const Divider(),

          _SectionHeader(title: "Прогресс"),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Экспорт / Импорт"),
            subtitle: const Text("CSV, Anki"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⬜ Экспорт — заглушка")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text("Сбросить прогресс"),
            subtitle: const Text("Удалить все данные"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⬜ Сброс — заглушка")),
              );
            },
          ),
          const Divider(),

          _SectionHeader(title: "О приложении"),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Версия"),
            subtitle: const Text("2.0.0+1"),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
