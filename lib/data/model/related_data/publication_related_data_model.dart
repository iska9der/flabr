import 'package:equatable/equatable.dart';

import 'related_data_base.dart';

class PublicationRelatedData extends RelatedDataBase with EquatableMixin {
  const PublicationRelatedData({
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

  factory PublicationRelatedData.fromMap(Map<String, dynamic> map) {
    return PublicationRelatedData(
      unreadCommentsCount: (map['unreadCommentsCount'] ?? 0) as int,
      bookmarked: (map['bookmarked'] ?? false) as bool,
      canComment: (map['canComment'] ?? false) as bool,
      canEdit: (map['canEdit'] ?? false) as bool,
      canViewVotes: (map['canViewVotes'] ?? false) as bool,
      canVotePlus: (map['canVotePlus'] ?? false) as bool,
      canVoteMinus: (map['canVoteMinus'] ?? false) as bool,
    );
  }

  static const empty = PublicationRelatedData();
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
