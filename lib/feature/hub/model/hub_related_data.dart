import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../data/model/related_data.dart';

class HubRelatedData extends RelatedDataBase with EquatableMixin {
  const HubRelatedData({
    this.isSubscribed = false,
  });

  final bool isSubscribed;

  static const empty = HubRelatedData();
  bool get isEmpty => this == empty;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isSubscribed': isSubscribed,
    };
  }

  factory HubRelatedData.fromMap(Map<String, dynamic> map) {
    return HubRelatedData(
      isSubscribed: (map['isSubscribed'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory HubRelatedData.fromJson(String source) =>
      HubRelatedData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [isSubscribed];
}
