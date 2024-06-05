part of 'config_model.dart';

/// Конфигурация ленты с постами
class FeedConfigModel extends Equatable {
  const FeedConfigModel({
    this.isImageVisible = true,
    this.isDescriptionVisible = false,
  });

  /// видимость изображений
  final bool isImageVisible;

  /// видимость короткого описания
  final bool isDescriptionVisible;

  FeedConfigModel copyWith({
    bool? isImageVisible,
    bool? isDescriptionVisible,
  }) {
    return FeedConfigModel(
      isImageVisible: isImageVisible ?? this.isImageVisible,
      isDescriptionVisible: isDescriptionVisible ?? this.isDescriptionVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isImageVisible': isImageVisible,
      'isDescriptionVisible': isDescriptionVisible,
    };
  }

  factory FeedConfigModel.fromMap(Map<String, dynamic> map) {
    return FeedConfigModel(
      isImageVisible: (map['isImageVisible'] ?? false) as bool,
      isDescriptionVisible: (map['isDescriptionVisible'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedConfigModel.fromJson(String source) => FeedConfigModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  static const empty = FeedConfigModel();

  @override
  List<Object> get props => [isImageVisible, isDescriptionVisible];
}
