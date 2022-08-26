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
  String get label {
    switch (this) {
      case FlowEnum.all:
        return 'Все';

      case FlowEnum.develop:
        return 'Разработка';

      case FlowEnum.admin:
        return 'Администрирование';

      case FlowEnum.design:
        return 'Дизайн';

      case FlowEnum.management:
        return 'Менеджмент';

      case FlowEnum.marketing:
        return 'Маркетинг';

      case FlowEnum.popsci:
        return 'Научпоп';
    }
  }
}
