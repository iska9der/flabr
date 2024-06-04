// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MiscConfigModel extends Equatable {
  const MiscConfigModel({this.navigationOnScrollVisible = true});
  final bool navigationOnScrollVisible;

  static const empty = MiscConfigModel();

  MiscConfigModel copyWith({
    bool? navigationOnScrollVisible,
  }) {
    return MiscConfigModel(
      navigationOnScrollVisible:
          navigationOnScrollVisible ?? this.navigationOnScrollVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'navigationOnScrollVisible': navigationOnScrollVisible,
    };
  }

  factory MiscConfigModel.fromMap(Map<String, dynamic> map) {
    return MiscConfigModel(
      navigationOnScrollVisible:
          (map['navigationOnScrollVisible'] ?? true) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MiscConfigModel.fromJson(String source) =>
      MiscConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [navigationOnScrollVisible];
}
