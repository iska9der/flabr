import 'package:equatable/equatable.dart';

import '../../../data/model/related_data.dart';

class CompanyRelatedData extends RelatedDataBase with EquatableMixin {
  const CompanyRelatedData({this.isSubscribed = false});

  final bool isSubscribed;

  static const empty = CompanyRelatedData();
  bool get isEmpty => this == empty;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isSubscribed': isSubscribed,
    };
  }

  factory CompanyRelatedData.fromMap(Map<String, dynamic> map) {
    return CompanyRelatedData(
      isSubscribed: (map['isSubscribed'] ?? false) as bool,
    );
  }

  @override
  List<Object?> get props => [isSubscribed];
}
