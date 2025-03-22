import 'package:freezed_annotation/freezed_annotation.dart';

import 'tracker_notification_publication.dart';
import 'tracker_notification_user.dart';

part 'tracker_notification_data.freezed.dart';
part 'tracker_notification_data.g.dart';

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

Object? _publicationReader(Map json, String key) {
  if (key == 'publication') {
    return json['post'] ?? json['thread'];
  }

  return json[key];
}
