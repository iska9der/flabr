import 'package:flutter/material.dart';

import '../../data/model/sort/sort_date_period_enum.dart';
import '../../data/model/sort/sort_enum.dart';
import '../../data/model/sort/sort_option_model.dart';
import '../../data/model/sort/sort_score_enum.dart';
import 'publication_sort_options_widget.dart';

class PublicationSort extends StatelessWidget {
  const PublicationSort({
    super.key,
    required this.sortBy,
    required this.sortByChange,
    required this.sortByDetail,
    required this.sortByDetailChange,
    this.isLoading = false,
  });

  final bool isLoading;

  final Sort sortBy;
  final Function(SortOption option) sortByChange;

  final dynamic sortByDetail;
  final Function(SortOption option) sortByDetailChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PublicationSortOptions(
          isEnabled: !isLoading,
          options: Sort.values
              .map((sort) => SortOption(
                    label: sort.label,
                    value: sort,
                  ))
              .toList(),
          currentValue: sortBy,
          onSelected: sortByChange,
        ),
        PublicationSortOptions(
          isEnabled: !isLoading,
          options: switch (sortBy) {
            Sort.byNew => SortScore.values
                .map((score) => SortOption(
                      label: score.label,
                      value: score.value,
                    ))
                .toList(),
            Sort.byBest => SortDatePeriod.values
                .map((period) => SortOption(
                      label: period.label,
                      value: period,
                    ))
                .toList(),
          },
          currentValue: sortByDetail,
          onSelected: sortByDetailChange,
        ),
      ],
    );
  }
}
