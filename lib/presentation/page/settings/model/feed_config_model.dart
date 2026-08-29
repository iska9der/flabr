part of 'config_model.dart';

enum FeedNavigationMode {
  infiniteScroll('Бесконечная прокрутка'),
  pagination('По страницам');

  const FeedNavigationMode(this.label);

  final String label;
}

@freezed
abstract class FeedConfigModel with _$FeedConfigModel {
  const FeedConfigModel._();

  const factory FeedConfigModel({
    @Default(true) bool isImageVisible,
    @Default(false) bool isDescriptionVisible,
    @Default(FeedNavigationMode.infiniteScroll)
    FeedNavigationMode navigationMode,
  }) = _FeedConfigModel;

  static const empty = FeedConfigModel();

  factory FeedConfigModel.fromJson(Map<String, dynamic> json) =>
      _$FeedConfigModelFromJson(json);
}
