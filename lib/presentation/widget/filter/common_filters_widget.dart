import 'package:flutter/material.dart';

import '../../../data/model/filter/filter.dart';
import 'filter_chip_list.dart';
import 'publication_filter_submit_button.dart';

class CommonFiltersWidget extends StatefulWidget {
  const CommonFiltersWidget({
    super.key,
    this.isLoading = false,
    required this.sort,
    required this.filterOption,
    this.onSubmit,
  });

  final bool isLoading;
  final Sort sort;
  final FilterOption filterOption;
  final void Function(FlowFilter filter)? onSubmit;

  @override
  State<CommonFiltersWidget> createState() => _CommonFiltersWidgetState();
}

class _CommonFiltersWidgetState extends State<CommonFiltersWidget> {
  late Sort sortValue = widget.sort;
  late FilterOption optionValue = widget.filterOption;

  @override
  void didUpdateWidget(covariant CommonFiltersWidget oldWidget) {
    if (oldWidget.sort != widget.sort ||
        oldWidget.filterOption != widget.filterOption) {
      sortValue = widget.sort;
      optionValue = widget.filterOption;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FilterChipList(
          isEnabled: !widget.isLoading,
          options:
              Sort.values
                  .map((e) => FilterOption(label: e.label, value: e.name))
                  .toList(),
          isSelected: (option) => option.value == sortValue.name,
          onSelected:
              (isSelected, option) => setState(() {
                sortValue = Sort.fromString(option.value);
                optionValue = sortValue.filters.first;
              }),
        ),
        FilterChipList(
          isEnabled: !widget.isLoading,
          options: sortValue.filters,
          isSelected: (option) => option == optionValue,
          onSelected:
              (isSelected, option) => setState(() {
                optionValue = option;
              }),
        ),
        if (widget.onSubmit != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: PublicationFilterSubmitButton(
              isEnabled: !widget.isLoading,
              onSubmit: () {
                FlowFilter newFilter = FlowFilter(sort: sortValue);

                switch (sortValue) {
                  case Sort.byBest:
                    newFilter = newFilter.copyWith(period: optionValue);
                  case Sort.byNew:
                    newFilter = newFilter.copyWith(score: optionValue);
                }

                widget.onSubmit!(newFilter);
              },
            ),
          ),
      ],
    );
  }
}
