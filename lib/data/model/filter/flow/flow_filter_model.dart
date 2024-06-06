part of '../part.dart';

@freezed
class FlowFilter with _$FlowFilter {
  const factory FlowFilter({
    @Default(Sort.byNew) Sort sort,
    @Default(FilterList.dateDefault) FilterOption period,
    @Default(FilterList.scoreDefault) FilterOption score,
  }) = _FlowFilter;

  factory FlowFilter.fromJson(Map<String, dynamic> json) =>
      _$FlowFilterFromJson(json);
}
