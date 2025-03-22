import 'package:freezed_annotation/freezed_annotation.dart';

import '../filter_list.dart';
import '../filter_option_model.dart';
import '../sort_enum.dart';

part 'flow_filter_model.freezed.dart';
part 'flow_filter_model.g.dart';

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
