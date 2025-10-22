/// Модель ярлыка быстрого доступа
class Shortcut {
  const Shortcut({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? icon;
}
