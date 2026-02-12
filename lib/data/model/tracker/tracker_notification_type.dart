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
    TrackerNotificationType.unknown => 'Что-то произошло с',
    TrackerNotificationType.postAdd ||
    TrackerNotificationType.threadAdd => 'Опубликовал новую публикацию',
    TrackerNotificationType.postAddToFavorite ||
    TrackerNotificationType.threadAddToFavorite =>
      'Добавил в закладки новую публикацию',
  };
}
