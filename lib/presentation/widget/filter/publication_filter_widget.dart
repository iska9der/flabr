import 'package:flutter/material.dart';

import '../../../data/model/filter/part.dart';
import 'publication_filter_options_widget.dart';
import 'publication_filter_submit_button.dart';

class PublicationFilterWidget extends StatefulWidget {
  const PublicationFilterWidget({
    super.key,
    this.isLoading = false,
    required this.sort,
    required this.filterOption,
    this.onSubmit,
  });

  final bool isLoading;

  final Sort sort;

  final FilterOption filterOption;

  final Function(FlowFilter filter)? onSubmit;

  @override
  State<PublicationFilterWidget> createState() =>
      _PublicationFilterWidgetState();
}

class _PublicationFilterWidgetState extends State<PublicationFilterWidget> {
  late Sort sortValue = widget.sort;
  late FilterOption optionValue = widget.filterOption;

  @override
  void didUpdateWidget(covariant PublicationFilterWidget oldWidget) {
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
        PublicationFilterOptionsWidget(
          isEnabled: !widget.isLoading,
          options: Sort.values
              .map((e) => FilterOption(label: e.label, value: e.name))
              .toList(),
          isSelected: (option) => option.value == sortValue.name,
          onSelected: (isSelected, option) => setState(() {
            sortValue = Sort.fromString(option.value);
            optionValue = sortValue.filters.first;
          }),
        ),
        PublicationFilterOptionsWidget(
          isEnabled: !widget.isLoading,
          options: sortValue.filters,
          isSelected: (option) => option == optionValue,
          onSelected: (isSelected, option) => setState(() {
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
