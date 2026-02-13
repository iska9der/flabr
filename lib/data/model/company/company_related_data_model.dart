import 'package:equatable/equatable.dart';

import '../related_data_base.dart';

class CompanyRelatedData extends RelatedDataBase with EquatableMixin {
  const CompanyRelatedData({this.isSubscribed = false});

  final bool isSubscribed;

  static const empty = CompanyRelatedData();
  bool get isEmpty => this == empty;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'isSubscribed': isSubscribed};
  }

  factory CompanyRelatedData.fromMap(Map<String, dynamic> map) {
    return CompanyRelatedData(
      isSubscribed: (map['isSubscribed'] ?? false) as bool,
    );
  }

  @override
  List<Object?> get props => [isSubscribed];
}
