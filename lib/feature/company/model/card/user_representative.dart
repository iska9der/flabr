import 'package:equatable/equatable.dart';

class UserRepresentative extends Equatable {
  const UserRepresentative({
    this.alias = '',
    this.fullname = '',
  });

  final String alias;
  final String fullname;

  String get name => fullname.isNotEmpty ? fullname : alias;

  UserRepresentative copyWith({
    String? alias,
    String? fullname,
  }) {
    return UserRepresentative(
      alias: alias ?? this.alias,
      fullname: fullname ?? this.fullname,
    );
  }

  factory UserRepresentative.fromMap(Map<String, dynamic> map) {
    return UserRepresentative(
      alias: (map['alias'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
    );
  }

  static const empty = UserRepresentative();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [alias, fullname];
}
