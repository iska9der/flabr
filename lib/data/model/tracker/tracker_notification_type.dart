part of 'tracker.dart';

enum TrackerNotificationType {
  unknown,
  postAdd,
  postAddToFavorite,
  threadAdd,
  threadAddToFavorite;

  factory TrackerNotificationType.fromString(String value) => switch (value) {
    'post_add' => TrackerNotificationType.postAdd,
    'post_add_to_favorite' => TrackerNotificationType.postAddToFavorite,
    'thread_add' => TrackerNotificationType.threadAdd,
    'thread_add_to_favorite' => TrackerNotificationType.threadAddToFavorite,
    _ => TrackerNotificationType.unknown,
  };

  String get text => switch (this) {
    TrackerNotificationType.unknown => t.tracker.somethingHappenedTo,
    TrackerNotificationType.postAdd ||
    TrackerNotificationType.threadAdd => t.tracker.publishedNewPost,
    TrackerNotificationType.postAddToFavorite ||
    TrackerNotificationType.threadAddToFavorite => t.tracker.bookmarkedNewPost,
  };
}
