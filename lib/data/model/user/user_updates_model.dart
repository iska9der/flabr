import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_updates_model.freezed.dart';
part 'user_updates_model.g.dart';

@freezed
class UserUpdates with _$UserUpdates {
  const factory UserUpdates({
    @Default(0) int conversationUnreadCount,
    @Default(0) int trackerUnreadCount,
  }) = _UserUpdates;

  factory UserUpdates.fromJson(Map<String, dynamic> json) =>
      _$UserUpdatesFromJson(json);
}
