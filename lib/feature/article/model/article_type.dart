import '../../../common/exception/value_exception.dart';

enum ArticleType {
  article,
  post,
  news,
  megaproject,

  /// Этот тип постов прилетает к нам, но мы не понимать каково их предназначение.
  /// Почти все поля у них пустые.
  /// Похоже на рекламные завлекательные вставки между постами.
  ///
  ///
  ///
  /// Типичный представитель:
  ///
  /// ```
  ///
  /// "id": "592771",
  /// "timePublished": "2021-12-01T10:58:55+00:00",
  /// "isCorporative": false,
  /// "lang": "ru",
  /// "titleHtml": "",
  /// "editorVersion": "1.0",
  /// "postType": "voice",
  /// "postLabels": [],
  /// "author": null,
  /// "statistics": null,
  /// "hubs": [],
  /// "flows": [],
  /// "relatedData": null,
  /// "leadData": {
  ///     "textHtml": "Карма ⩾10? <a href=\"https://habra-adm.ru/\" rel=\"nofollow noopener noreferrer\">Стань</a> Анонимным Дедом Морозом 🎅",
  ///     "imageUrl": null,
  ///     "buttonTextHtml": null,
  ///     "image": null
  /// },
  /// ```
  ///
  voice;

  factory ArticleType.fromString(String value) {
    return ArticleType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ValueException('Тип статьи $value не существует'),
    );
  }
}
