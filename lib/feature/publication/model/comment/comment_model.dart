// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../../../common/model/comment.dart';
import '../publication_author_model.dart';

class CommentModel extends CommentBase with EquatableMixin {
  const CommentModel({
    required super.id,
    super.author = PublicationAuthorModel.empty,
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
    this.parent,
    super.childrenRaw = const [],
    this.children = const [],
  });

  @override
  PublicationAuthorModel get author => super.author as PublicationAuthorModel;

  final CommentModel? parent;

  final List<CommentModel> children;

  @override
  CommentModel copyWith({
    String? id,
    PublicationAuthorModel? author,
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
    CommentModel? parent,
    List<String>? childrenRaw,
    List<CommentModel>? children,
  }) {
    return CommentModel(
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
      parent: parent ?? this.parent,
      childrenRaw: childrenRaw ?? this.childrenRaw,
      children: children ?? this.children,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      parentId: map['parentId'] ?? '',
      author: map['author'] != null && map['author'].isNotEmpty
          ? PublicationAuthorModel.fromMap(map['author'])
          : PublicationAuthorModel.empty,
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
        parent,
        childrenRaw,
        children,
      ];
}
