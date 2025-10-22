import 'package:quick_actions/quick_actions.dart';

import 'shortcut.dart';
import 'shortcut_mapper.dart';

/// Обработчик ярлыков быстрого доступа.
/// Класс-прослойка для взаимодействия с библиотекой quick_actions.
class QuickShortcuts {
  QuickShortcuts();

  final ShortcutMapper _mapper = const ShortcutMapper();
  final QuickActions _library = const QuickActions();

  /// Инициализирует обработчик ярлыков с callback-функцией.
  ///
  /// [onShortcutTap] - функция, которая будет вызвана при нажатии на ярлык.
  /// Принимает [id] нажатого ярлыка.
  Future<void> onStart(void Function(String id) onShortcutTap) async {
    return _library.initialize(onShortcutTap);
  }

  /// Устанавливает список ярлыков быстрого доступа.
  ///
  /// [shortcuts] - список ярлыков для установки.
  Future<void> setShortcuts(List<Shortcut> shortcuts) async {
    final items = _mapper.toShortcutItems(shortcuts);
    return _library.setShortcutItems(items);
  }

  /// Очищает все ярлыки быстрого доступа.
  Future<void> clearShortcuts() async {
    return _library.clearShortcutItems();
  }
}
