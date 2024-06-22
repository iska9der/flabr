part of 'part.dart';

@freezed
class TrackerNotification with _$TrackerNotification {
  const factory TrackerNotification({
    required String id,
    @Default(TrackerNotificationCategory.unknown)
    TrackerNotificationCategory category,
    @JsonKey(fromJson: TrackerNotificationType.fromJson)
    @Default(TrackerNotificationType.unknown)
    TrackerNotificationType type,
    required bool unread,
    required bool unviewed,
    DateTime? timeHappened,
    @Default(TrackerNotificationData()) TrackerNotificationData data,
  }) = _TrackerNotification;

  factory TrackerNotification.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationFromJson(json);
}

enum TrackerNotificationCategory {
  unknown,
  system,
  mentions,
  subscribers,
  ;
}

enum TrackerNotificationType {
  unknown,
  postAddToFavorite,
  threadAddToFavorite,
  ;

  String toJson() => name;

  factory TrackerNotificationType.fromJson(String value) => switch (value) {
        'post_add_to_favorite' => TrackerNotificationType.postAddToFavorite,
        'thread_add_to_favorite' => TrackerNotificationType.threadAddToFavorite,
        _ => TrackerNotificationType.unknown,
      };

  String get text => switch (this) {
        TrackerNotificationType.unknown => 'Что-то произошло с',
        TrackerNotificationType.postAddToFavorite ||
        TrackerNotificationType.threadAddToFavorite =>
          'Добавил в закладки новую публикацию',
      };
}

Object? _publicationReader(Map json, String key) {
  if (key == 'publication') {
    return json['post'] ?? json['thread'];
  }

  return json[key];
}

@freezed
class TrackerNotificationData with _$TrackerNotificationData {
  const factory TrackerNotificationData({
    TrackerNotificationUser? user,
    @JsonKey(name: 'publication', readValue: _publicationReader)
    TrackerNotificationPublication? publication,
  }) = _TrackerNotificationData;

  factory TrackerNotificationData.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationDataFromJson(json);
}

@freezed
class TrackerNotificationUser with _$TrackerNotificationUser {
  const factory TrackerNotificationUser({
    @Default('') String login,
    @Default('') String fullname,
    @Default('') String avatarUrl,
  }) = _TrackerNotificationUser;

  factory TrackerNotificationUser.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationUserFromJson(json);
}

Object? _typeReader(Map json, String key) {
  if (key == 'type') {
    return json['postType'] ?? json['publicationType'];
  }

  return json[key];
}

Object? _textReader(Map json, String key) {
  if (key == 'text') {
    return json['titleHtml'] ?? json['preview'];
  }

  return json[key];
}

@freezed
class TrackerNotificationPublication with _$TrackerNotificationPublication {
  const TrackerNotificationPublication._();

  const factory TrackerNotificationPublication({
    required String id,
    @JsonKey(name: 'type', readValue: _typeReader) @Default('') String type,
    @JsonKey(name: 'text', readValue: _textReader) @Default('') String text,
    @JsonKey(fromJson: PublicationAuthor.fromMap)
    @Default(PublicationAuthor.empty)
    PublicationAuthor author,
    @Default(0) int commentsCount,
    @Default(0) int unreadCommentsCount,
  }) = _TrackerNotificationPublication;

  static const empty = TrackerNotificationPublication(id: '0');

  factory TrackerNotificationPublication.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationPublicationFromJson(json);
}
