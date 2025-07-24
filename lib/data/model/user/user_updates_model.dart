import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_updates_model.freezed.dart';
part 'user_updates_model.g.dart';

@freezed
abstract class UserUpdates with _$UserUpdates {
  const factory UserUpdates({
    @Default(UserUpdatesFeeds()) UserUpdatesFeeds feeds,
    @Default(0) int conversationUnreadCount,
    @Default(0) int trackerUnreadCount,
  }) = _UserUpdates;

  factory UserUpdates.fromJson(Map<String, dynamic> json) =>
      _$UserUpdatesFromJson(json);

  static const UserUpdates empty = UserUpdates();
}

@freezed
abstract class UserUpdatesFeeds with _$UserUpdatesFeeds {
  const factory UserUpdatesFeeds({
    @Default(0) int newPostsCount,
    @Default(0) int newThreadsCount,
    @Default(0) int newNewsCount,
    @Default(0) int newCount,
  }) = _UserUpdatesFeeds;

  factory UserUpdatesFeeds.fromJson(Map<String, dynamic> json) =>
      _$UserUpdatesFeedsFromJson(json);
}
