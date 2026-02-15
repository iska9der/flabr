import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:quick_shortcuts/quick_shortcuts.dart';

import '../logger/logger.dart';
import '../router/router.dart';
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
  ShortcutsManager(this._logger, this._router);

  final Logger _logger;
  final AppRouter _router;
  final QuickShortcuts _quickShortcuts = QuickShortcuts();
  final String icon = 'ic_launcher';

  /// Инициализирует ярлыки быстрого доступа.
  ///
  /// Устанавливает обработчик нажатий и создает список доступных ярлыков.
  /// Если [user] не авторизован (isEmpty), ярлык закладок не отображается.
  Future<void> createShortcuts({bool isAuthorized = false}) async {
    try {
      final shortcuts = _getShortcuts(isAuthorized);
      await _quickShortcuts.setShortcuts(shortcuts);
    } catch (e, stackTrace) {
      _logger.error('Не удалось инициализировать ярлыки', e, stackTrace);
    }
  }

  /// Обработка нажатия на ярлык быстрого доступа
  Future<void> handleShortcuts() => _quickShortcuts.onStart(_handleShortcutTap);

  /// Обрабатывает нажатие на ярлык.
  ///
  /// Выполняет навигацию в соответствующий раздел приложения.
  void _handleShortcutTap(String id) {
    final action = ShortcutAction.fromId(id);
    if (action == null) {
      _logger.warning('Неизвестный action ярлыка: $id');
      return;
    }

    final route = _getRouteForAction(action);
    _router.navigate(route);
  }

  /// Получить route для действия с учетом текущего пользователя
  PageRouteInfo _getRouteForAction(ShortcutAction action) {
    return switch (action) {
      .bookmarks => ProfileDashboardRoute(
        children: [UserBookmarkListRoute()],
      ),
      .articles => const PublicationDashboardRoute(
        children: [ArticlesFlowRoute()],
      ),
      .news => const PublicationDashboardRoute(
        children: [NewsFlowRoute()],
      ),
      .posts => const PublicationDashboardRoute(
        children: [PostsFlowRoute()],
      ),
      .search => const SearchAnywhereRoute(),
    };
  }

  /// Список доступных ярлыков приложения.
  /// Фильтрует закладки для неавторизованных пользователей.
  List<Shortcut> _getShortcuts(bool isAuthorized) {
    final isUserSpecific = [ShortcutAction.bookmarks];

    final actions = switch (isAuthorized) {
      true => ShortcutAction.values,
      false =>
        ShortcutAction.values
            .where((action) => !isUserSpecific.any((a) => a == action))
            .toList(),
    };

    return actions
        .map(
          (action) => Shortcut(
            id: action.id,
            title: action.title,
            icon: icon,
          ),
        )
        .toList();
  }
}
