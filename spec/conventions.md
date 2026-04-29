# Конвенции

## Архитектура

- Чистая архитектура (domain → data → presentation)
- Provider для state management (ChangeNotifier)
- GoRouter для навигации (НЕ Navigator.push)
- AppServices — DI-контейнер (синглтон)
- **НИКОГДА** не создавать репозитории/сервисы вручную — только через AppServices
- **НЕ вызывать API напрямую из UI** — всегда через сервисы/провайдеры

## State Management

- `setState()` — только для UI-состояния (анимации, видимость, scroll position, selected tab индекс и т.д.)
- ChangeNotifier — для бизнес-состояния (списки, loading, error, data mutations)

### Пример разделения

```dart
// ❌ Плохо: бизнес-данные через setState
setState(() { _isSaving = true; });
await provider.saveCard(card);
setState(() { _isSaving = false; });

// ✅ Хорошо: UI-состояние (видимость панели) — setState
setState(() { _isExpanded = !_isExpanded; });

// ✅ Бизнес-состояние (saving, data) — Provider
context.read<DeckProvider>().saveDeck(name);
// UI слушает loading через context.watch<DeckProvider>().isLoading
```
- `Consumer<T>` / `context.watch<T>()` — подписка на изменения
- `context.read<T>()` — одноразовый вызов (onPressed, initState)
- Разделять UI-состояние и бизнес-состояние
- Избегать лишних ребилдов — выносить виджеты, использовать const
- Использовать `Selector<T, S>` для точечной подписки на часть стейта

## Naming

| Что | Как | Пример |
|-----|-----|--------|
| Провайдеры | XxxProvider | DeckProvider |
| Сервисы | XxxService | DatabaseService |
| Страницы | XxxPage | HomePage |
| Виджеты | XxxWidget | AppBottomNavigationBar |
| ViewModel | XxxViewModel | GameViewModel |
| Репозиторий (абстр.) | XxxRepository | DeckRepository |
| Репозиторий (impl) | XxxRepositoryImpl | DeckRepositoryImpl |

## Асинхронность

- `mounted` check после `await` перед использованием context
- `try-catch` на асинхронных операциях
- `initState` → `addPostFrameCallback` для вызовов провайдеров

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<WordCardProvider>().loadCards(widget.deckId);
  });
}
```

## UI

- const конструкторы где возможно
- Маленькие переиспользуемые виджеты (< 300 строк)
- Никаких виджетов > 300 строк без необходимости
- Material 3
- Responsive layout (проверять на разных размерах)
- Использовать дизайн-систему (app_colors, app_theme)

## Навигация

- Все пути — через GoRouter
- Route constants в `lib/route/router.dart`
- Параметры маршрутов — pathParameters или extra
- Error screen — зарегистрирован в GoRouter

## Кодстайл

- `flutter analyze` — чистый проход перед коммитом
- Нет хардкода там, где есть константы
- `dispose()` для всех контроллеров, стримов, подписок

---

## Приложение: Pre-commit Checklist

### Code Quality
- [ ] Нет хардкода (строки, цвета, числа)
- [ ] Соблюдены naming конвенции
- [ ] AppServices используется правильно
- [ ] Нет прямых API вызовов из UI

### Navigation
- [ ] GoRouter, не Navigator.push
- [ ] Нет хардкода маршрутов (только route constants)

### Safety
- [ ] mounted check после await
- [ ] try-catch для async операций
- [ ] dispose() для контроллеров

### UI
- [ ] Responsive layout
- [ ] Использует дизайн-систему (theme, colors)
- [ ] Виджеты < 300 строк
- [ ] const конструкторы

### Performance
- [ ] const виджеты
- [ ] Нет лишних ребилдов

### Validation
- [ ] `flutter analyze` — чистый проход
- [ ] Нет runtime-ошибок
- [ ] Фича работает end-to-end
