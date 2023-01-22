import '../exception/value_exception.dart';

enum HubType {
  collective,
  corporative;

  factory HubType.fromString(String value) {
    return HubType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ValueException('Неизвестный тип хаба'),
    );
  }
}

extension HubTypeX on HubType {
  bool get isCollective => this == HubType.collective;
  bool get isCorporative => this == HubType.corporative;
}
