part of 'publication.dart';

enum PublicationComplexity {
  low,
  medium,
  high;

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
    PublicationComplexity.low => t.publication.complexity.easy,
    PublicationComplexity.medium => t.publication.complexity.medium,
    PublicationComplexity.high => t.publication.complexity.hard,
  };
}
