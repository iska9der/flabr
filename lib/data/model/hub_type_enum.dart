import '../exception/exception.dart';

enum HubType {
  collective,
  corporative;

  bool get isCollective => this == HubType.collective;
  bool get isCorporative => this == HubType.corporative;

  factory HubType.fromString(String value) {
    return HubType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw const ValueException('Неизвестный тип хаба'),
    );
  }
}
