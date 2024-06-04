import '../exception/part.dart';

enum HubType {
  collective,
  corporative;

  bool get isCollective => this == HubType.collective;
  bool get isCorporative => this == HubType.corporative;

  factory HubType.fromString(String value) {
    return HubType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ValueException('Неизвестный тип хаба'),
    );
  }
}
