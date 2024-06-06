part of 'config_model.dart';

class MiscConfigModel extends Equatable {
  const MiscConfigModel({this.navigationOnScrollVisible = true});

  final bool navigationOnScrollVisible;

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

  static const empty = MiscConfigModel();

  String toJson() => json.encode(toMap());

  factory MiscConfigModel.fromJson(String source) =>
      MiscConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [navigationOnScrollVisible];
}
