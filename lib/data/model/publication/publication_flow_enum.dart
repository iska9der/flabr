part of 'publication.dart';

enum PublicationFlow {
  all,
  develop,
  admin,
  design,
  management,
  marketing,
  popsci
  ;

  String get label => switch (this) {
    .all => 'Все',
    .develop => 'Разработка',
    .admin => 'Администрирование',
    .design => 'Дизайн',
    .management => 'Менеджмент',
    .marketing => 'Маркетинг',
    .popsci => 'Научпоп',
  };

  static PublicationFlow fromString(String value) {
    return .values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ValueException('Неизвестное значение PublicationFlow: $value');
      },
    );
  }
}
