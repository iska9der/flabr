import 'package:equatable/equatable.dart';

import '../../../common/model/user.dart';

class PublicationAuthorModel extends UserBase with EquatableMixin {
  const PublicationAuthorModel({
    required super.id,
    super.alias = '',
    super.fullname = '',
    super.avatarUrl = '',
    this.speciality = '',
  });

  final String speciality;

  factory PublicationAuthorModel.fromMap(Map<String, dynamic> map) {
    return PublicationAuthorModel(
      id: map['id'],
      alias: map['alias'],
      fullname: map['fullname'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      speciality: map['speciality'] ?? '',
    );
  }

  static const empty = PublicationAuthorModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        id,
        alias,
        fullname,
        avatarUrl,
        speciality,
      ];
}
