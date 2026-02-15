part of 'company_card_model.dart';

class CompanyUserRepresentative with EquatableMixin {
  const CompanyUserRepresentative({this.alias = '', this.fullname = ''});

  final String alias;
  final String fullname;

  String get name => fullname.isNotEmpty ? fullname : alias;

  CompanyUserRepresentative copyWith({String? alias, String? fullname}) {
    return CompanyUserRepresentative(
      alias: alias ?? this.alias,
      fullname: fullname ?? this.fullname,
    );
  }

  factory CompanyUserRepresentative.fromMap(Map<String, dynamic> map) {
    return CompanyUserRepresentative(
      alias: (map['alias'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
    );
  }

  static const empty = CompanyUserRepresentative();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [alias, fullname];
}
