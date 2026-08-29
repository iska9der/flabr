import '../../../../i18n/i18n.dart';
import '../../../exception/exception.dart';

enum FeedFilterPublication {
  articles,
  posts,
  news;

  String get label => switch (this) {
    FeedFilterPublication.articles => t.shortcut.articles,
    FeedFilterPublication.posts => t.shortcut.posts,
    FeedFilterPublication.news => t.shortcut.news,
  };

  factory FeedFilterPublication.fromString(String value) =>
      FeedFilterPublication.values.firstWhere(
        (type) => type.name == value,
        orElse: () => throw ValueException(t.feed.publicationUnknownType),
      );
}
