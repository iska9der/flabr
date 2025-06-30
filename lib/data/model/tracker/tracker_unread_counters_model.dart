import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracker_unread_counters_model.freezed.dart';
part 'tracker_unread_counters_model.g.dart';

@freezed
abstract class TrackerUnreadCounters with _$TrackerUnreadCounters {
  const factory TrackerUnreadCounters({
    @Default(0) int publicationComments,
    @Default(0) int publicationCommentsByAuthor,
    @Default(0) int total,
    @Default(0) int subscribers,
    @Default(0) int mentions,
    @Default(0) int system,
    @Default(0) int applications,
  }) = _TrackerUnreadCounters;

  factory TrackerUnreadCounters.fromJson(Map<String, dynamic> json) =>
      _$TrackerUnreadCountersFromJson(json);
}
