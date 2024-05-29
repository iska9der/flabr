import 'package:flutter/material.dart';

import '../../model/sort/feed_publication_type.dart';
import '../../model/sort/score_enum.dart';
import '../../model/sort/sort_option_model.dart';
import 'sort_options_widget.dart';

class FeedSortWidget extends StatelessWidget {
  const FeedSortWidget({
    super.key,
    this.isLoading = false,
    required this.currentScore,
    required this.onScoreChange,
    required this.currentTypes,
    required this.onTypesChange,
  });

  final bool isLoading;

  final ScoreEnum currentScore;
  final Function(SortOptionModel score) onScoreChange;

  final List<FeedPublicationType> currentTypes;
  final void Function(List<FeedPublicationType> newTypes) onTypesChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Тип публикации',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: FeedPublicationType.values
              .map((type) => ChoiceChip(
                    label: Text(type.label),
                    selected: currentTypes.contains(type),
                    onSelected: (isSelected) {
                      if (isSelected) {
                        final newTypes = [...currentTypes, type];
                        return onTypesChange(newTypes);
                      }

                      onTypesChange(
                        [...currentTypes]
                          ..removeWhere((element) => element == type),
                      );
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
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
