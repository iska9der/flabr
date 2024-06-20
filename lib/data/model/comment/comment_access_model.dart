import 'package:equatable/equatable.dart';

class CommentAccess extends Equatable {
  const CommentAccess({
    this.isCanComment = false,
    this.cantCommentReason = '',
    this.cantCommentReasonKey = '',
  });

  final bool isCanComment;
  final String cantCommentReason;
  final String cantCommentReasonKey;

  CommentAccess copyWith({
    bool? isCanComment,
    String? cantCommentReason,
    String? cantCommentReasonKey,
  }) {
    return CommentAccess(
      isCanComment: isCanComment ?? this.isCanComment,
      cantCommentReason: cantCommentReason ?? this.cantCommentReason,
      cantCommentReasonKey: cantCommentReasonKey ?? this.cantCommentReasonKey,
    );
  }

  factory CommentAccess.fromMap(Map<String, dynamic> map) {
    return CommentAccess(
      isCanComment: map['isCanComment'] ?? false,
      cantCommentReason: map['cantCommentReason'] ?? '',
      cantCommentReasonKey: map['cantCommentReasonKey'] ?? '',
    );
  }

  static const empty = CommentAccess();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        isCanComment,
        cantCommentReason,
        cantCommentReasonKey,
      ];
}
