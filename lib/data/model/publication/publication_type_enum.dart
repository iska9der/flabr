part of 'publication.dart';

@JsonEnum()
enum PublicationType {
  /// для всех неопознанных типов
  unknown,
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
  /// "publicationType": "voice",
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

  String get label => switch (this) {
    PublicationType.unknown => t.publication.typeUnknown,
    PublicationType.article => t.publication.typeArticle,
    PublicationType.post => t.publication.typePost,
    PublicationType.news => t.publication.typeNews,
    PublicationType.megaproject => t.publication.typeMegaproject,
    PublicationType.voice => t.publication.typeVoice,
  };

  factory PublicationType.fromString(String value) {
    return PublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => PublicationType.unknown,
    );
  }
}
