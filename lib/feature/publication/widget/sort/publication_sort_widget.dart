import 'package:flutter/material.dart';

import '../../../publication/model/sort/date_period_enum.dart';
import '../../../publication/model/sort/sort_enum.dart';
import '../../../publication/model/sort/sort_option_model.dart';
import '../../model/sort/score_enum.dart';
import 'sort_options_widget.dart';

class PublicationSortWidget extends StatelessWidget {
  const PublicationSortWidget({
    super.key,
    required this.sortBy,
    required this.sortByChange,
    required this.sortByDetail,
    required this.sortByDetailChange,
    this.isLoading = false,
  });

  final bool isLoading;

  final SortEnum sortBy;
  final Function(SortOptionModel option) sortByChange;

  final dynamic sortByDetail;
  final Function(SortOptionModel option) sortByDetailChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SortOptionsWidget(
          isEnabled: !isLoading,
          options: SortEnum.values
              .map((sort) => SortOptionModel(
                    label: sort.label,
                    value: sort,
                  ))
              .toList(),
          currentValue: sortBy,
          onSelected: sortByChange,
        ),
        SortOptionsWidget(
          isEnabled: !isLoading,
          options: switch (sortBy) {
            SortEnum.byNew => ScoreEnum.values
                .map((score) => SortOptionModel(
                      label: score.label,
                      value: score.value,
                    ))
                .toList(),
            SortEnum.byBest => DatePeriodEnum.values
                .map((period) => SortOptionModel(
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
