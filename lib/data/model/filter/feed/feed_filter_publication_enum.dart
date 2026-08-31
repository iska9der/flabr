import '../../../../i18n/i18n.dart';
import '../../../exception/exception.dart';

enum FeedFilterPublication {
  articles,
  posts,
  news;

  String get label => switch (this) {
    FeedFilterPublication.articles => t.feed.publication.types.articles,
    FeedFilterPublication.posts => t.feed.publication.types.posts,
    FeedFilterPublication.news => t.feed.publication.types.news,
  };

  factory FeedFilterPublication.fromString(String value) =>
      FeedFilterPublication.values.firstWhere(
        (type) => type.name == value,
        orElse: () => throw const ValueException(.unknownFeedPublication),
      );
}
