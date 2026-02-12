part of 'tracker.dart';

@freezed
abstract class TrackerPublication with _$TrackerPublication {
  const TrackerPublication._();

  const factory TrackerPublication({
    required String id,
    required String publicationType,
    required String title,
    @JsonKey(fromJson: PublicationAuthor.fromMap)
    @Default(PublicationAuthor.empty)
    PublicationAuthor author,
    @Default(0) int commentsCount,
    @Default(0) int unreadCommentsCount,
  }) = _TrackerPublication;

  factory TrackerPublication.fromJson(Map<String, dynamic> json) =>
      _$TrackerPublicationFromJson(json);

  bool get isUnread => unreadCommentsCount > 0;
}
