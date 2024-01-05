import 'package:equatable/equatable.dart';

import '../../publication/model/publication_type.dart';

class UserCommentPublication extends Equatable {
  const UserCommentPublication({
    required this.id,
    this.type = PublicationType.article,
    this.title = '',
  });

  final String id;
  final String title;
  final PublicationType type;

  factory UserCommentPublication.fromMap(Map<String, dynamic> map) {
    return UserCommentPublication(
      id: map['id'],
      type: map.containsKey('postType')
          ? PublicationType.fromString(map['postType'])
          : PublicationType.article,
      title: map['title'] ?? '',
    );
  }

  static const empty = UserCommentPublication(id: '0');

  @override
  List<Object> get props => [id, type, title];
}
