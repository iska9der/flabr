// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../common/model/related_data.dart';

class ArticleRelatedData extends RelatedDataBase with EquatableMixin {
  const ArticleRelatedData({
    this.unreadCommentsCount = 0,
    this.bookmarked = false,
    this.canComment = false,
    this.canEdit = false,
    this.canVote = false,
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
  final bool canVote;
  final bool canComment;
  final bool canEdit;
  final bool canViewVotes;
  final bool canVotePlus;
  final bool canVoteMinus;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'unreadCommentsCount': unreadCommentsCount,
      'bookmarked': bookmarked,
      'canVote': canVote,
      'canComment': canComment,
      'canEdit': canEdit,
      'canViewVotes': canViewVotes,
      'canVotePlus': canVotePlus,
      'canVoteMinus': canVoteMinus,
    };
  }

  factory ArticleRelatedData.fromMap(Map<String, dynamic> map) {
    return ArticleRelatedData(
      unreadCommentsCount: (map['unreadCommentsCount'] ?? 0) as int,
      bookmarked: (map['bookmarked'] ?? false) as bool,
      canVote: (map['canVote'] ?? false) as bool,
      canComment: (map['canComment'] ?? false) as bool,
      canEdit: (map['canEdit'] ?? false) as bool,
      canViewVotes: (map['canViewVotes'] ?? false) as bool,
      canVotePlus: (map['canVotePlus'] ?? false) as bool,
      canVoteMinus: (map['canVoteMinus'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleRelatedData.fromJson(String source) =>
      ArticleRelatedData.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = ArticleRelatedData();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        unreadCommentsCount,
        bookmarked,
        canVote,
        canComment,
        canEdit,
        canViewVotes,
        canVotePlus,
        canVoteMinus,
      ];
}
