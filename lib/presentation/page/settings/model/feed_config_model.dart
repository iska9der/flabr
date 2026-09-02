part of 'config_model.dart';

enum FeedNavigationMode {
  infiniteScroll,
  pagination;

  String get label => switch (this) {
    FeedNavigationMode.infiniteScroll =>
      t.settings.feed.pageLoading.mode.infiniteScroll,
    FeedNavigationMode.pagination =>
      t.settings.feed.pageLoading.mode.pagination,
  };
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
