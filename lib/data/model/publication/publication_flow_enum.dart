import '../../exception/exception.dart';

enum PublicationFlow {
  all,
  develop,
  admin,
  design,
  management,
  marketing,
  popsci;

  String get label => switch (this) {
    PublicationFlow.all => 'Все',
    PublicationFlow.develop => 'Разработка',
    PublicationFlow.admin => 'Администрирование',
    PublicationFlow.design => 'Дизайн',
    PublicationFlow.management => 'Менеджмент',
    PublicationFlow.marketing => 'Маркетинг',
    PublicationFlow.popsci => 'Научпоп',
  };

  static PublicationFlow fromString(String value) {
    return PublicationFlow.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ValueException('Неизвестное значение');
      },
    );
  }
}
