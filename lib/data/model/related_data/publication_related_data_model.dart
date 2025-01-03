import 'package:freezed_annotation/freezed_annotation.dart';

import 'publication_vote_model.dart';
import 'related_data_base.dart';

part 'publication_related_data_model.freezed.dart';
part 'publication_related_data_model.g.dart';

@freezed
class PublicationRelatedData extends RelatedDataBase
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
    @Default(PublicationVoteModel.empty) PublicationVoteModel votePlus,
    @Default(PublicationVoteModel.empty) PublicationVoteModel voteMinus,
  }) = _PublicationRelatedData;

  factory PublicationRelatedData.fromJson(Map<String, dynamic> map) =>
      _$PublicationRelatedDataFromJson(map);

  static const empty = PublicationRelatedData();
  bool get isEmpty => this == empty;
}
