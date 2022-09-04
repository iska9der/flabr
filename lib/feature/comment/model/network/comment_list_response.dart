import 'package:equatable/equatable.dart';

import '../comment_access_model.dart';
import '../comment_model.dart';

class CommentListResponse extends Equatable {
  const CommentListResponse({
    this.commentAccess = CommentAccessModel.empty,
    this.comments = const [],
    this.lastCommentTimestamp = 0,
  });

  final CommentAccessModel commentAccess;
  final List<CommentModel> comments;
  final int lastCommentTimestamp;

  DateTime get lastCommentAt => DateTime.fromMillisecondsSinceEpoch(
        lastCommentTimestamp * 1000,
      );

  CommentListResponse copyWith({
    CommentAccessModel? commentAccess,
    List<CommentModel>? comments,
    int? lastCommentTimestamp,
  }) {
    return CommentListResponse(
      commentAccess: commentAccess ?? this.commentAccess,
      comments: comments ?? this.comments,
      lastCommentTimestamp: lastCommentTimestamp ?? this.lastCommentTimestamp,
    );
  }

  factory CommentListResponse.fromMap(Map<String, dynamic> map) {
    return CommentListResponse(
      commentAccess: map['commentAccess'] != null
          ? CommentAccessModel.fromMap(map['commentAccess'])
          : CommentAccessModel.empty,
      comments: map['comments'] != null
          ? List<CommentModel>.from(Map.from(map['comments']).entries.map(
                (x) => CommentModel.fromMap(x.value),
              ))
          : const [],
      lastCommentTimestamp: map['lastCommentTimestamp'] ?? 0,
    );
  }

  static const empty = CommentListResponse();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [commentAccess, comments, lastCommentTimestamp];

  List<CommentModel> structurize() {
    if (comments.isEmpty) return [];

    List<CommentModel> newComments = [];

    comments.where((element) => element.level == 0).forEach((comment) {
      comment = _recursive(comments, comment);

      newComments.add(comment);
    });

    newComments.sort((a, b) => a.publishedAt.isBefore(b.publishedAt) ? 0 : 1);

    return newComments;
  }
}

CommentModel _recursive(
  List<CommentModel> comments,
  CommentModel parent,
) {
  if (parent.childrenRaw.isNotEmpty) {
    var childs = parent.childrenRaw
        .map((id) => comments.firstWhere((element) => element.id == id))
        .toList();

    List<CommentModel> newChilds = [];

    for (var child in childs) {
      var newChild = _recursive(comments, child);
      newChilds.add(newChild);
    }

    parent = parent.copyWith(children: newChilds);
  }

  return parent;
}
