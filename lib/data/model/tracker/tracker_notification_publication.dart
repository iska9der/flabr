part of 'tracker.dart';

@freezed
abstract class TrackerNotificationPublication
    with _$TrackerNotificationPublication {
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

Object? _typeReader(Map<dynamic, dynamic> json, String key) {
  if (key == 'type') {
    return json['postType'] ?? json['publicationType'];
  }

  return json[key];
}

Object? _textReader(Map<dynamic, dynamic> json, String key) {
  if (key == 'text') {
    return json['titleHtml'] ?? json['preview'];
  }

  return json[key];
}
