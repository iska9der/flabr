import 'package:equatable/equatable.dart';

import '../related_data_base.dart';

class HubRelatedData extends RelatedDataBase with EquatableMixin {
  const HubRelatedData({this.isSubscribed = false});

  final bool isSubscribed;

  static const empty = HubRelatedData();
  bool get isEmpty => this == empty;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'isSubscribed': isSubscribed};
  }

  factory HubRelatedData.fromJson(Map<String, dynamic> map) {
    return HubRelatedData(isSubscribed: (map['isSubscribed'] ?? false) as bool);
  }

  @override
  List<Object> get props => [isSubscribed];
}
