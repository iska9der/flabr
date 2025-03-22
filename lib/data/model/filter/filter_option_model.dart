import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_option_model.freezed.dart';
part 'filter_option_model.g.dart';

@freezed
abstract class FilterOption with _$FilterOption {
  const factory FilterOption({required String label, required String value}) =
      _FilterOption;

  factory FilterOption.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionFromJson(json);
}
