import 'user.dart';

class CommentBase {
  const CommentBase({
    required this.id,
    required this.author,
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
  });

  final String id;
  final String parentId;
  final UserBase author;

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
  final List<String> childrenRaw;

  CommentBase copyWith() {
    throw UnimplementedError();
  }

  factory CommentBase.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
