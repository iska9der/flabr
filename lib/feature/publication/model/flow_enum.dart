import '../../../common/exception/value_exception.dart';

enum FlowEnum {
  all,
  develop,
  admin,
  design,
  management,
  marketing,
  popsci;

  static FlowEnum fromString(String value) {
    return FlowEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ValueException('Неизвестное значение');
      },
    );
  }
}

extension FlowX on FlowEnum {
  String get label => switch (this) {
        FlowEnum.all => 'Все',
        FlowEnum.develop => 'Разработка',
        FlowEnum.admin => 'Администрирование',
        FlowEnum.design => 'Дизайн',
        FlowEnum.management => 'Менеджмент',
        FlowEnum.marketing => 'Маркетинг',
        FlowEnum.popsci => 'Научпоп'
      };
}
