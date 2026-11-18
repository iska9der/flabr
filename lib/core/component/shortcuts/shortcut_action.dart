import 'package:collection/collection.dart';

/// Действия быстрого доступа, доступные в приложении
enum ShortcutAction {
  bookmarks('action_bookmarks'),
  articles('action_articles'),
  search('action_search');

  const ShortcutAction(this.id);

  final String id;

  /// Получить ShortcutAction по ID
  static ShortcutAction? fromId(String id) {
    return ShortcutAction.values.firstWhereOrNull((e) => e.id == id);
  }
}
