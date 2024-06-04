import 'package:equatable/equatable.dart';

import '../../../../../data/model/comment_base.dart';
import '../../../../../data/model/publication/publication_author_model.dart';
import 'user_comment_publication_model.dart';

class UserCommentModel extends CommentBase with EquatableMixin {
  const UserCommentModel({
    required super.id,
    super.author = PublicationAuthor.empty,
    super.isPostAuthor = false,
    super.isAuthor = false,
    super.isFavorite = false,
    super.isNew = false,
    super.isPinned = false,
    super.isSuspended = false,
    super.isCanEdit = false,
    super.message = '',
    super.status = '',
    super.timeChanged,
    super.timeEditAllowedTill,
    super.timePublished = '',
    super.score = 0,
    super.votesCount = 0,
    super.level = 0,
    super.parentId = '',
    super.childrenRaw = const [],
    this.publication = UserCommentPublication.empty,
  });

  @override
  PublicationAuthor get author => super.author as PublicationAuthor;

  final UserCommentPublication publication;

  @override
  UserCommentModel copyWith({
    String? id,
    PublicationAuthor? author,
    bool? isPostAuthor,
    bool? isFavorite,
    bool? isNew,
    bool? isPinned,
    bool? isSuspended,
    bool? isAuthor,
    bool? isCanEdit,
    String? message,
    String? status,
    String? timeChanged,
    String? timeEditAllowedTill,
    String? timePublished,
    int? score,
    int? votesCount,
    int? level,
    String? parentId,
    List<String>? childrenRaw,
    UserCommentPublication? publication,
  }) {
    return UserCommentModel(
      id: id ?? this.id,
      author: author ?? this.author,
      isPostAuthor: isPostAuthor ?? this.isPostAuthor,
      isFavorite: isFavorite ?? this.isFavorite,
      isNew: isNew ?? this.isNew,
      isPinned: isPinned ?? this.isPinned,
      isSuspended: isSuspended ?? this.isSuspended,
      isAuthor: isAuthor ?? this.isAuthor,
      isCanEdit: isCanEdit ?? this.isCanEdit,
      message: message ?? this.message,
      status: status ?? this.status,
      timeChanged: timeChanged ?? this.timeChanged,
      timeEditAllowedTill: timeEditAllowedTill ?? this.timeEditAllowedTill,
      timePublished: timePublished ?? this.timePublished,
      score: score ?? this.score,
      votesCount: votesCount ?? this.votesCount,
      level: level ?? this.level,
      parentId: parentId ?? this.parentId,
      childrenRaw: childrenRaw ?? this.childrenRaw,
      publication: publication ?? this.publication,
    );
  }

  factory UserCommentModel.fromMap(Map<String, dynamic> map) {
    return UserCommentModel(
      id: map['id'],
      parentId: map['parentId'] ?? '',
      author: map['author'] != null && map['author'].isNotEmpty
          ? PublicationAuthor.fromMap(map['author'])
          : PublicationAuthor.empty,
      isPostAuthor: map['isPostAuthor'] as bool,
      isAuthor: map['isAuthor'] as bool,
      isFavorite: map['isFavorite'] as bool,
      isNew: map['isNew'] as bool,
      isPinned: map['isPinned'] as bool,
      isSuspended: map['isSuspended'] as bool,
      isCanEdit: map['isCanEdit'] as bool,
      message: map['message'] ?? '',
      status: map['status'] ?? '',
      timeChanged: map['timeChanged'],
      timeEditAllowedTill: map['timeEditAllowedTill'],
      timePublished: map['timePublished'] ?? '',
      score: map['score'],
      votesCount: map['votesCount'],
      level: map['level'],
      childrenRaw: map['children'] != null
          ? List<String>.from(map['children'])
          : const [],
      publication: map['publication'] != null
          ? UserCommentPublication.fromMap(map['publication'])
          : UserCommentPublication.empty,
    );
  }

  @override
  List<Object?> get props => [
        id,
        author,
        isPostAuthor,
        isAuthor,
        isFavorite,
        isNew,
        isPinned,
        isSuspended,
        isCanEdit,
        message,
        status,
        timeChanged,
        timeEditAllowedTill,
        timePublished,
        publishedAt,
        score,
        votesCount,
        level,
        parentId,
        childrenRaw,
        publication,
      ];
}
