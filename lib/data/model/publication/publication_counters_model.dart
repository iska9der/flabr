import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_counters_model.freezed.dart';
part 'publication_counters_model.g.dart';

@freezed
class PublicationCounters with _$PublicationCounters {
  const factory PublicationCounters({
    @JsonKey(name: 'countPosts') @Default(0) int articles,
    @JsonKey(name: 'countNews') @Default(0) int news,
    @JsonKey(name: 'countThreads') @Default(0) int posts,
  }) = _PublicationCounters;

  factory PublicationCounters.fromJson(Map<String, dynamic> json) =>
      _$PublicationCountersFromJson(json);
}
