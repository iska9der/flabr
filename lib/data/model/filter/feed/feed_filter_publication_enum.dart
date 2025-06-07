import '../../../exception/exception.dart';

enum FeedFilterPublication {
  articles(label: 'Статьи'),
  posts(label: 'Посты'),
  news(label: 'Новости');

  const FeedFilterPublication({required this.label});

  final String label;

  factory FeedFilterPublication.fromString(String value) =>
      FeedFilterPublication.values.firstWhere(
        (type) => type.name == value,
        orElse: () => throw const ValueException('Неизвестный тип'),
      );
}
