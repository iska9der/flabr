import 'package:freezed_annotation/freezed_annotation.dart';

import '../filter_list.dart';
import '../filter_option_model.dart';
import 'feed_filter_publication_enum.dart';

part 'feed_filter_model.freezed.dart';
part 'feed_filter_model.g.dart';

@freezed
abstract class FeedFilter with _$FeedFilter {
  const factory FeedFilter({
    @Default(FilterList.scoreDefault) FilterOption score,
    @Default(FeedFilterPublication.values) List<FeedFilterPublication> types,
  }) = _FeedFilter;

  factory FeedFilter.fromJson(Map<String, dynamic> json) =>
      _$FeedFilterFromJson(json);
}
