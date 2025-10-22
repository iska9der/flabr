import 'package:quick_actions/quick_actions.dart';

import 'shortcut.dart';

/// Маппер для преобразования между моделями Shortcut и ShortcutItem
class ShortcutMapper {
  const ShortcutMapper();

  /// Преобразует модель приложения в модель библиотеки quick_actions
  ShortcutItem toShortcutItem(Shortcut shortcut) {
    return ShortcutItem(
      type: shortcut.id,
      localizedTitle: shortcut.title,
      localizedSubtitle: shortcut.subtitle,
      icon: shortcut.icon,
    );
  }

  /// Преобразует список моделей приложения в список моделей библиотеки
  List<ShortcutItem> toShortcutItems(List<Shortcut> shortcuts) {
    return shortcuts.map(toShortcutItem).toList();
  }
}
