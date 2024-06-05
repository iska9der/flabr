part of '../part.dart';

@freezed
class FeedFilter with _$FeedFilter {
  const factory FeedFilter({
    @Default(FilterList.scoreDefault) FilterOption score,
    @Default(FeedFilterPublication.values) List<FeedFilterPublication> types,
  }) = _FeedFilter;

  factory FeedFilter.fromJson(Map<String, dynamic> json) =>
      _$FeedFilterFromJson(json);
}
