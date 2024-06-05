// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class FilterOption extends Equatable {
  final String label;
  final String value;

  const FilterOption({
    required this.label,
    required this.value,
  });

  @override
  List<Object> get props => [label, value];
}
