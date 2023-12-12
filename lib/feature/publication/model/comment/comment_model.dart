// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../publication_author_model.dart';

class CommentModel extends Equatable {
  const CommentModel({
    required this.id,
    this.author = PublicationAuthorModel.empty,
    this.isPostAuthor = false,
    this.isAuthor = false,
    this.isFavorite = false,
    this.isNew = false,
    this.isPinned = false,
    this.isSuspended = false,
    this.isCanEdit = false,
    this.message = '',
    this.status = '',
    this.timeChanged,
    this.timeEditAllowedTill,
    this.timePublished = '',
    this.score = 0,
    this.votesCount = 0,
    this.level = 0,
    this.parentId = '',
    this.childrenRaw = const [],
    this.children = const [],
  });

  final String id;
  final PublicationAuthorModel author;

  final bool isPostAuthor;
  final bool isAuthor;
  final bool isFavorite;
  final bool isNew;
  final bool isPinned;
  final bool isSuspended;
  final bool isCanEdit;

  final String message;
  final String status;

  final String? timeChanged;
  final String? timeEditAllowedTill;
  final String timePublished;
  DateTime get publishedAt => DateTime.parse(timePublished).toLocal();

  final int score;
  final int votesCount;

  final int level;
  final String parentId;
  final List<String> childrenRaw;
  final List<CommentModel> children;

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
      childrenRaw: childrenRaw ?? this.childrenRaw,
      children: children ?? this.children,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
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
      parentId: map['parentId'] ?? '',
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
        score,
        votesCount,
        level,
        parentId,
        childrenRaw,
        children,
      ];
}
