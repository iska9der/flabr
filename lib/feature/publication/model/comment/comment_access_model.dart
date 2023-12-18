import 'package:equatable/equatable.dart';

class CommentAccessModel extends Equatable {
  const CommentAccessModel({
    this.isCanComment = false,
    this.cantCommentReason = '',
    this.cantCommentReasonKey = '',
  });

  final bool isCanComment;
  final String cantCommentReason;
  final String cantCommentReasonKey;

  CommentAccessModel copyWith({
    bool? isCanComment,
    String? cantCommentReason,
    String? cantCommentReasonKey,
  }) {
    return CommentAccessModel(
      isCanComment: isCanComment ?? this.isCanComment,
      cantCommentReason: cantCommentReason ?? this.cantCommentReason,
      cantCommentReasonKey: cantCommentReasonKey ?? this.cantCommentReasonKey,
    );
  }

  factory CommentAccessModel.fromMap(Map<String, dynamic> map) {
    return CommentAccessModel(
      isCanComment: map['isCanComment'] ?? false,
      cantCommentReason: map['cantCommentReason'] ?? '',
      cantCommentReasonKey: map['cantCommentReasonKey'] ?? '',
    );
  }

  static const empty = CommentAccessModel();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        isCanComment,
        cantCommentReason,
        cantCommentReasonKey,
      ];
}
