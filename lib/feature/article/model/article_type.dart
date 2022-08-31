import '../../../common/exception/value_exception.dart';

enum ArticleType {
  article,
  news,
  megaproject;

  factory ArticleType.fromString(String value) {
    return ArticleType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ValueException('Тип статьи $value не существует'),
    );
  }
}
