import 'package:flutter/material.dart';

import '../../data/model/filter/part.dart';
import 'publication_filter_options_widget.dart';

class PublicationFilterWidget extends StatelessWidget {
  const PublicationFilterWidget({
    super.key,
    required this.sort,
    required this.onSortChange,
    required this.filterOption,
    required this.onOptionChange,
    this.isLoading = false,
  });

  final bool isLoading;

  final Sort sort;
  final Function(Sort sort) onSortChange;

  final FilterOption filterOption;
  final Function(FilterOption option) onOptionChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PublicationFilterOptionsWidget(
          isEnabled: !isLoading,
          options: Sort.values
              .map((e) => FilterOption(label: e.label, value: e.name))
              .toList(),
          currentValue: FilterOption(label: sort.label, value: sort.name),
          onSelected: (option) => onSortChange(Sort.fromString(option.value)),
        ),
        PublicationFilterOptionsWidget(
          isEnabled: !isLoading,
          options: sort.filters,
          currentValue: filterOption,
          onSelected: onOptionChange,
        ),
      ],
    );
  }
}
