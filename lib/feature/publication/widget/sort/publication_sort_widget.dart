import 'package:flutter/material.dart';

import '../../../publication/model/sort/date_period_enum.dart';
import '../../../publication/model/sort/sort_enum.dart';
import '../../../publication/model/sort/sort_option_model.dart';
import '../../model/sort/score_enum.dart';
import 'sort_options_widget.dart';

part 'sort_by_widget.dart';

class PublicationSortWidget extends StatelessWidget {
  const PublicationSortWidget({
    super.key,
    required this.sortValue,
    required this.sortChange,
    required this.optionValue,
    required this.optionChange,
    this.isLoading = false,
  });

  final bool isLoading;
  final SortEnum sortValue;
  final Function(SortEnum sort) sortChange;

  final dynamic optionValue;
  final Function(SortOptionModel option) optionChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SortByWidget(
          isEnabled: !isLoading,
          currentValue: sortValue,
          onTap: (sort) => sortChange(sort),
        ),
        SortOptionsWidget(
          isEnabled: !isLoading,
          options: switch (sortValue) {
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
          currentValue: optionValue,
          onSelected: (option) => optionChange(option),
        ),
      ],
    );
  }
}
