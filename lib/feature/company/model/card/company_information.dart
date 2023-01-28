// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'user_representative.dart';

const _placeholderDate = '2000-01-01T10:10:00+00:00';

class CompanyInformation extends Equatable {
  const CompanyInformation({
    this.foundationDate = '',
    this.registrationDate = _placeholderDate,
    this.siteUrl = '',
    this.staffNumber = '',
    this.representativeUser = UserRepresentative.empty,
  });

  final String foundationDate;
  final String registrationDate;
  final String siteUrl;
  final String staffNumber;
  final UserRepresentative representativeUser;

  DateTime get registeredAt => DateTime.parse(registrationDate).toLocal();
  String get foundedAt {
    final spl = foundationDate.split('null.');

    var result = '';

    for (var s in spl) {
      result += s;
    }

    return result;
  }

  CompanyInformation copyWith({
    String? foundationDate,
    String? registrationDate,
    String? siteUrl,
    String? staffNumber,
    UserRepresentative? representativeUser,
  }) {
    return CompanyInformation(
      foundationDate: foundationDate ?? this.foundationDate,
      registrationDate: registrationDate ?? this.registrationDate,
      siteUrl: siteUrl ?? this.siteUrl,
      staffNumber: staffNumber ?? this.staffNumber,
      representativeUser: representativeUser ?? this.representativeUser,
    );
  }

  factory CompanyInformation.fromMap(Map<String, dynamic> map) {
    final userMap = map['representativeUser'] as Map<String, dynamic>?;

    return CompanyInformation(
      foundationDate: map['foundationDate'] != null
          ? '${map['foundationDate']['day']}.${map['foundationDate']['month']}.${map['foundationDate']['year']}'
          : '',
      registrationDate: (map['registrationDate'] ?? _placeholderDate) as String,
      siteUrl: (map['siteUrl'] ?? '') as String,
      staffNumber: (map['staffNumber'] ?? '') as String,
      representativeUser: userMap != null
          ? UserRepresentative.fromMap(userMap)
          : const UserRepresentative(),
    );
  }

  static const CompanyInformation empty = CompanyInformation();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props {
    return [
      foundationDate,
      registrationDate,
      siteUrl,
      staffNumber,
      representativeUser,
    ];
  }
}
