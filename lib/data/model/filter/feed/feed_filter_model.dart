import 'package:freezed_annotation/freezed_annotation.dart';

import '../filter_list.dart';
import '../filter_option_model.dart';
import '../publication_criteria.dart';

part 'feed_filter_model.freezed.dart';
part 'feed_filter_model.g.dart';

@freezed
abstract class FeedFilter with _$FeedFilter {
  const factory FeedFilter({
    @Default(PublicationCriteria()) PublicationCriteria criteria,
    @Default(FilterList.scoreDefault) FilterOption score,
  }) = _FeedFilter;

  factory FeedFilter.fromJson(Map<String, dynamic> json) =>
      _$FeedFilterFromJson(json);
}
