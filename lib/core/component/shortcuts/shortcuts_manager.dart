import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:quick_shortcuts/quick_shortcuts.dart';

import '../../../data/model/user/user_me_model.dart';
import '../logger/logger.dart';
import '../router/app_router.dart';
import 'shortcut_action.dart';

/// Менеджер для управления ярлыками быстрого доступа приложения.
///
/// Предоставляет ярлыки для быстрого доступа к основным разделам:
/// - Закладки (только для авторизованных пользователей)
/// - Статьи
/// - Новости
/// - Посты
@singleton
class ShortcutsManager {
  ShortcutsManager(this._router);

  final AppRouter _router;
  final QuickShortcuts _quickShortcuts = QuickShortcuts();

  /// Текущий пользователь для формирования ярлыка закладок
  UserMe _currentUser = UserMe.empty;

  /// Инициализирует ярлыки быстрого доступа.
  ///
  /// Устанавливает обработчик нажатий и создает список доступных ярлыков.
  /// Если [user] не авторизован (isEmpty), ярлык закладок не отображается.
  Future<void> init(UserMe user) async {
    _currentUser = user;

    try {
      await _quickShortcuts.onStart(_handleShortcutTap);

      final shortcuts = _getShortcuts();
      await _quickShortcuts.setShortcuts(shortcuts);
    } catch (e, stackTrace) {
      logger.error('Не удалось инициализировать ярлыки', e, stackTrace);
    }
  }

  /// Обрабатывает нажатие на ярлык.
  ///
  /// Выполняет навигацию в соответствующий раздел приложения.
  void _handleShortcutTap(String id) {
    final action = ShortcutAction.fromId(id);
    if (action == null) {
      logger.warning('Неизвестный action ярлыка: $id');
      return;
    }

    final route = _getRouteForAction(action);
    _router.push(route);
  }

  /// Получить route для действия с учетом текущего пользователя
  PageRouteInfo _getRouteForAction(ShortcutAction action) {
    return switch (action) {
      ShortcutAction.bookmarks => UserDashboardRoute(
        alias: _currentUser.alias,
        children: [UserBookmarkListRoute()],
      ),
      ShortcutAction.articles => const ArticlesFlowRoute(),
      ShortcutAction.news => const NewsFlowRoute(),
      ShortcutAction.posts => const PostsFlowRoute(),
      ShortcutAction.search => const SearchAnywhereRoute(),
    };
  }

  /// Список доступных ярлыков приложения.
  /// Фильтрует закладки для неавторизованных пользователей.
  List<Shortcut> _getShortcuts() {
    final isUserSpecific = [ShortcutAction.bookmarks];

    final actions = switch (_currentUser.isEmpty) {
      true =>
        ShortcutAction.values
            .where((action) => !isUserSpecific.any((a) => a == action))
            .toList(),
      false => ShortcutAction.values,
    };

    return actions
        .map(
          (action) => Shortcut(
            id: action.id,
            title: action.title,
            // icon: можно добавить в enum при необходимости
          ),
        )
        .toList();
  }
}
