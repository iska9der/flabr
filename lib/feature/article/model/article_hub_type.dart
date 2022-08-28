import '../../../common/exception/value_exception.dart';

enum ArticleHubType {
  collective,
  corporative;

  factory ArticleHubType.fromString(String value) {
    return ArticleHubType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ValueException('Неизвестный тип хаба'),
    );
  }
}
