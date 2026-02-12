part of 'publication.dart';

enum PublicationType {
  /// для всех неопознанных типов
  unknown(label: 'Неизвестно'),
  article(label: 'Статья'),
  post(label: 'Пост'),
  news(label: 'Новость'),
  megaproject(label: 'Мегапроект'),

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
  voice(label: 'Голос');

  const PublicationType({required this.label});

  final String label;

  factory PublicationType.fromString(String value) {
    return PublicationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => PublicationType.unknown,
    );
  }
}
