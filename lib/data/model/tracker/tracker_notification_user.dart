part of 'tracker.dart';

@freezed
class TrackerNotificationUser
    with _$TrackerNotificationUser
    implements UserBase {
  const factory TrackerNotificationUser({
    @Default('') String id,
    @JsonKey(name: 'login') @Default('') String alias,
    @Default('') String fullname,
    @Default('') String avatarUrl,
  }) = _TrackerNotificationUser;

  factory TrackerNotificationUser.fromJson(Map<String, dynamic> json) =>
      _$TrackerNotificationUserFromJson(json);
}
