import '../../exception/exception.dart';

enum PublicationComplexity {
  low,
  medium,
  high;

  factory PublicationComplexity.fromString(String value) {
    return PublicationComplexity.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ValueException('Неизвестное значение');
      },
    );
  }

  String get label => switch (this) {
    PublicationComplexity.low => 'Простой',
    PublicationComplexity.medium => 'Средний',
    PublicationComplexity.high => 'Сложный',
  };
}
