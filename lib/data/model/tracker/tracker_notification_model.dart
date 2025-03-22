import 'package:freezed_annotation/freezed_annotation.dart';

import 'tracker_notification_category.dart';
import 'tracker_notification_data.dart';
import 'tracker_notification_type.dart';

part 'tracker_notification_model.freezed.dart';
part 'tracker_notification_model.g.dart';

@freezed
class TrackerNotification with _$TrackerNotification {
  const TrackerNotification._();

  const factory TrackerNotification({
    required String id,
    @Default(TrackerNotificationCategory.unknown)
    TrackerNotificationCategory category,
    @Default('') String type,
    required bool unread,
    required bool unviewed,
    DateTime? timeHappened,
    @Default({}) Map<String, dynamic> data,
  }) = _TrackerNotification;

  factory TrackerNotification.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationFromJson(json);

  TrackerNotificationType get typeEnum =>
      TrackerNotificationType.fromString(type);

  TrackerNotificationData get dataModel =>
      TrackerNotificationData.fromJson(data);
}
