import 'package:flutter/material.dart';

import '../../model/sort/score_enum.dart';
import '../../model/sort/sort_option_model.dart';
import 'sort_options_widget.dart';

class FeedSortWidget extends StatelessWidget {
  const FeedSortWidget({
    super.key,
    required this.currentScore,
    required this.onScoreChange,
    this.isLoading = false,
  });

  final bool isLoading;

  final ScoreEnum currentScore;
  final Function(SortOptionModel score) onScoreChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Порог рейтинга',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SortOptionsWidget(
          isEnabled: !isLoading,
          options: ScoreEnum.values
              .map((e) => SortOptionModel(label: e.label, value: e.value))
              .toList(),
          currentValue: currentScore.value,
          onSelected: (value) => onScoreChange(value),
        ),
      ],
    );
  }
}
