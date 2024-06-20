import 'package:equatable/equatable.dart';

import '../comment/comment_access_model.dart';
import '../comment/comment_model.dart';

class CommentListResponse extends Equatable {
  const CommentListResponse({
    this.commentAccess = CommentAccess.empty,
    this.comments = const [],
    this.lastCommentTimestamp = 0,
  });

  final CommentAccess commentAccess;
  final List<Comment> comments;
  final int lastCommentTimestamp;

  DateTime get lastCommentAt => DateTime.fromMillisecondsSinceEpoch(
        lastCommentTimestamp * 1000,
      );

  CommentListResponse copyWith({
    CommentAccess? commentAccess,
    List<Comment>? comments,
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
          ? CommentAccess.fromMap(map['commentAccess'])
          : CommentAccess.empty,
      comments: map['comments'] != null
          ? List<Comment>.from(Map.from(map['comments']).entries.map(
                (x) => Comment.fromMap(x.value),
              ))
          : const [],
      lastCommentTimestamp: map['lastCommentTimestamp'] ?? 0,
    );
  }

  static const empty = CommentListResponse();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [commentAccess, comments, lastCommentTimestamp];

  /// Структуризируем комментарии
  ///
  /// А шо значит?
  ///
  /// А значит мы пересобираем комменты с уже вложенными детками
  /// с помощью рекурсивной функции [_recursive]
  List<Comment> structurize() {
    if (comments.isEmpty) return [];

    List<Comment> newComments = [];

    /// выбираем корневые комментарии, и запускаем
    /// для каждого папаши рекурсивную функцию сбора потомков
    comments.where((element) => element.level == 0).forEach((comment) {
      comment = _recursive(comments, comment);

      newComments.add(comment);
    });

    /// сортируем по дате публикации
    newComments.sort((a, b) => a.publishedAt.isBefore(b.publishedAt) ? 0 : 1);

    return newComments;
  }
}

Comment _recursive(
  List<Comment> comments,
  Comment parent,
) {
  /// если деток нет, возвращаем одинокого пахана домой
  if (!parent.childrenRaw.isNotEmpty) {
    return parent;
  }

  /// ищем детей
  var childs = parent.childrenRaw
      .map((id) => comments.firstWhere((element) => element.id == id))
      .toList();

  List<Comment> newChilds = [];

  for (var child in childs) {
    /// ищем внуков... вдруг и дети уже паханы?
    Comment newChild = _recursive(comments, child);
    newChild = newChild.copyWith(parent: parent);

    newChilds.add(newChild);
  }

  /// и возвращаем счатливого/грустного (сам смотри, пахан, ты уже взрослый)
  /// пахана/деда/прадеда с найденными потомками
  return parent.copyWith(children: newChilds);
}
