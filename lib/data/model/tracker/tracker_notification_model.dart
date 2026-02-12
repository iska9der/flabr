part of 'tracker.dart';

@freezed
abstract class TrackerNotification with _$TrackerNotification {
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
