part of 'filter.dart';

@freezed
abstract class FilterOption with _$FilterOption {
  const factory FilterOption({required String label, required String value}) =
      _FilterOption;

  factory FilterOption.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionFromJson(json);
}
