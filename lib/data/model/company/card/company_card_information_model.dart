part of 'company_card_model.dart';

const _placeholderDate = '2000-01-01T10:10:00+00:00';

class CompanyCardInformation extends Equatable {
  const CompanyCardInformation({
    this.foundationDate = '',
    this.registrationDate = _placeholderDate,
    this.siteUrl = '',
    this.staffNumber = '',
    this.representativeUser = CompanyUserRepresentative.empty,
  });

  final String foundationDate;
  final String registrationDate;
  final String siteUrl;
  final String staffNumber;
  final CompanyUserRepresentative representativeUser;

  DateTime get registeredAt => DateTime.parse(registrationDate).toLocal();
  String get foundedAt {
    final spl = foundationDate.split('null.');

    var result = '';

    for (var s in spl) {
      result += s;
    }

    return result;
  }

  CompanyCardInformation copyWith({
    String? foundationDate,
    String? registrationDate,
    String? siteUrl,
    String? staffNumber,
    CompanyUserRepresentative? representativeUser,
  }) {
    return CompanyCardInformation(
      foundationDate: foundationDate ?? this.foundationDate,
      registrationDate: registrationDate ?? this.registrationDate,
      siteUrl: siteUrl ?? this.siteUrl,
      staffNumber: staffNumber ?? this.staffNumber,
      representativeUser: representativeUser ?? this.representativeUser,
    );
  }

  factory CompanyCardInformation.fromMap(Map<String, dynamic> map) {
    final userMap = map['representativeUser'] as Map<String, dynamic>?;

    return CompanyCardInformation(
      foundationDate: map['foundationDate'] != null
          ? '${map['foundationDate']['day']}.${map['foundationDate']['month']}.${map['foundationDate']['year']}'
          : '',
      registrationDate: (map['registrationDate'] ?? _placeholderDate) as String,
      siteUrl: (map['siteUrl'] ?? '') as String,
      staffNumber: (map['staffNumber'] ?? '') as String,
      representativeUser: userMap != null
          ? CompanyUserRepresentative.fromMap(userMap)
          : const CompanyUserRepresentative(),
    );
  }

  static const CompanyCardInformation empty = CompanyCardInformation();
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
