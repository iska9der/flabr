part of 'tracker.dart';

@freezed
abstract class TrackerNotificationData with _$TrackerNotificationData {
  const factory TrackerNotificationData({
    TrackerNotificationUser? user,
    @JsonKey(name: 'publication', readValue: _publicationReader)
    TrackerNotificationPublication? publication,
  }) = _TrackerNotificationData;

  factory TrackerNotificationData.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationDataFromJson(json);
}

Object? _publicationReader(Map<dynamic, dynamic> json, String key) {
  if (key == 'publication') {
    return json['post'] ?? json['thread'];
  }

  return json[key];
}
