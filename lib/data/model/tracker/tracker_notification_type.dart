part of 'part.dart';

enum TrackerNotificationType {
  unknown,
  postAdd,
  postAddToFavorite,
  threadAddToFavorite,
  ;

  factory TrackerNotificationType.fromString(String value) => switch (value) {
        'post_add' => TrackerNotificationType.postAdd,
        'post_add_to_favorite' => TrackerNotificationType.postAddToFavorite,
        'thread_add_to_favorite' => TrackerNotificationType.threadAddToFavorite,
        _ => TrackerNotificationType.unknown,
      };

  String get text => switch (this) {
        TrackerNotificationType.unknown => 'Что-то произошло с',
        TrackerNotificationType.postAdd => 'Опубликовал новую публикацию',
        TrackerNotificationType.postAddToFavorite ||
        TrackerNotificationType.threadAddToFavorite =>
          'Добавил в закладки новую публикацию',
      };
}
