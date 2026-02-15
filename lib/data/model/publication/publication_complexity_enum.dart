part of 'publication.dart';

enum PublicationComplexity {
  low,
  medium,
  high
  ;

  static PublicationComplexity? fromString(String value) {
    final result = PublicationComplexity.values.firstWhereOrNull(
      (e) => e.name == value,
    );

    if (result == null) {
      getIt<Logger>().warning(
        'Неизвестное значение PublicationComplexity: $value',
      );
    }

    return result;
  }

  String get label => switch (this) {
    PublicationComplexity.low => 'Простой',
    PublicationComplexity.medium => 'Средний',
    PublicationComplexity.high => 'Сложный',
  };
}
