// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../common/model/related_data.dart';

class PublicationRelatedDataModel extends RelatedDataBase with EquatableMixin {
  const PublicationRelatedDataModel({
    this.unreadCommentsCount = 0,
    this.bookmarked = false,
    this.canComment = false,
    this.canEdit = false,
    this.canViewVotes = false,
    this.canVotePlus = false,
    this.canVoteMinus = false,
  });

  final int unreadCommentsCount;
  final bool bookmarked;
  // "vote": {
  //     "value": null,
  //     "voteTimeExpired": "2022-10-09T15:02:47+00:00"
  // },
  final bool canComment;
  final bool canEdit;
  final bool canViewVotes;
  final bool canVotePlus;
  final bool canVoteMinus;

  factory PublicationRelatedDataModel.fromMap(Map<String, dynamic> map) {
    return PublicationRelatedDataModel(
      unreadCommentsCount: (map['unreadCommentsCount'] ?? 0) as int,
      bookmarked: (map['bookmarked'] ?? false) as bool,
      canComment: (map['canComment'] ?? false) as bool,
      canEdit: (map['canEdit'] ?? false) as bool,
      canViewVotes: (map['canViewVotes'] ?? false) as bool,
      canVotePlus: (map['canVotePlus'] ?? false) as bool,
      canVoteMinus: (map['canVoteMinus'] ?? false) as bool,
    );
  }

  static const empty = PublicationRelatedDataModel();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        unreadCommentsCount,
        bookmarked,
        canComment,
        canEdit,
        canViewVotes,
        canVotePlus,
        canVoteMinus,
      ];
}
