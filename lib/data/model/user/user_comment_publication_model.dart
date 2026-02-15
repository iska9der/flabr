import 'package:equatable/equatable.dart';

import '../publication/publication.dart';

class UserCommentPublication with EquatableMixin {
  const UserCommentPublication({
    required this.id,
    this.type = PublicationType.unknown,
    this.title = '',
  });

  final String id;
  final String title;
  final PublicationType type;

  factory UserCommentPublication.fromMap(Map<String, dynamic> map) {
    return UserCommentPublication(
      id: map['id'],
      type: map.containsKey('publicationType')
          ? PublicationType.fromString(map['publicationType'])
          : PublicationType.unknown,
      title: map['title'] ?? '',
    );
  }

  static const empty = UserCommentPublication(id: '0');

  @override
  List<Object> get props => [id, type, title];
}
