import '../../../../common/exception/value_exception.dart';

enum ArticleComplexity {
  low,
  medium,
  high;

  factory ArticleComplexity.fromString(String value) {
    return ArticleComplexity.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ValueException('Неизвестное значение');
      },
    );
  }

  String get label => switch (this) {
        ArticleComplexity.low => 'Простой',
        ArticleComplexity.medium => 'Средний',
        ArticleComplexity.high => 'Сложный'
      };
}
