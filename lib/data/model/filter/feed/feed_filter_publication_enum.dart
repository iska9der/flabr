import '../../../../i18n/i18n.dart';
import '../../../exception/exception.dart';

enum FeedFilterPublication {
  articles,
  posts,
  news;

  String get label => switch (this) {
    FeedFilterPublication.articles => t.feed.publicationTypes.articles,
    FeedFilterPublication.posts => t.feed.publicationTypes.posts,
    FeedFilterPublication.news => t.feed.publicationTypes.news,
  };

  factory FeedFilterPublication.fromString(String value) =>
      FeedFilterPublication.values.firstWhere(
        (type) => type.name == value,
        orElse: () => throw const ValueException(.unknownFeedPublication),
      );
}
