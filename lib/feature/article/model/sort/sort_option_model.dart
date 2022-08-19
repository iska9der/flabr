// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SortOptionModel extends Equatable {
  final String label;
  final dynamic value;

  const SortOptionModel({
    required this.label,
    required this.value,
  });

  @override
  List<Object> get props => [label, value];
}
