import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_base.dart';

part 'tracker_notification_user.freezed.dart';
part 'tracker_notification_user.g.dart';

@freezed
abstract class TrackerNotificationUser
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
