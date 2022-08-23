enum FlowEnum {
  all('Все потоки', ''),
  develop('Разработка', 'develop'),
  admin('Администрирование', 'admin'),
  design('Дизайн', 'design'),
  management('Менеджмент', 'management'),
  marketing('Маркетинг', 'marketing'),
  popsci('Научпоп', 'popsci');

  const FlowEnum(this.label, this.path);

  final String label;
  final String path;
}
