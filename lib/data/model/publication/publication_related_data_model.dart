part of 'publication.dart';

@freezed
abstract class PublicationRelatedData extends RelatedDataBase
    with _$PublicationRelatedData {
  const PublicationRelatedData._();

  const factory PublicationRelatedData({
    @Default(0) int unreadCommentsCount,
    @Default(false) bool bookmarked,
    @Default(false) bool canComment,
    @Default(false) bool canEdit,
    @Default(false) bool canViewVotes,
    @Default(false) bool trackerSubscribed,
    @Default(false) bool emailSubscribed,
    @Default(PublicationVote.empty) PublicationVote vote,
    @Default(PublicationVoteAction.empty) PublicationVoteAction votePlus,
    @Default(PublicationVoteAction.empty) PublicationVoteAction voteMinus,
  }) = _PublicationRelatedData;

  factory PublicationRelatedData.fromJson(Map<String, dynamic> map) =>
      _$PublicationRelatedDataFromJson(map);

  static const empty = PublicationRelatedData();
  bool get isEmpty => this == empty;
}
