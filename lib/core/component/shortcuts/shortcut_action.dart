import 'package:collection/collection.dart';

/// Действия быстрого доступа, доступные в приложении
enum ShortcutAction {
  bookmarks('action_bookmarks', 'Закладки'),
  articles('action_articles', 'Статьи'),
  posts('action_posts', 'Посты'),
  news('action_news', 'Новости'),
  search('action_search', 'Поиск');

  const ShortcutAction(this.id, this.title);

  final String id;
  final String title;

  /// Получить ShortcutAction по ID
  static ShortcutAction? fromId(String id) {
    return ShortcutAction.values.firstWhereOrNull((e) => e.id == id);
  }
}
