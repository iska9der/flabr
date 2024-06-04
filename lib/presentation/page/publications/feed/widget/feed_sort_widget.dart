import 'package:flutter/material.dart';

import '../../../../../data/model/sort/sort_option_model.dart';
import '../../../../../data/model/sort/sort_score_enum.dart';
import '../../widget/publication_sort_options_widget.dart';
import '../model/feed_publication_type.dart';

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

  final SortScore currentScore;
  final Function(SortOption score) onScoreChange;

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
        PublicationSortOptions(
          isEnabled: !isLoading,
          options: SortScore.values
              .map((e) => SortOption(label: e.label, value: e.value))
              .toList(),
          currentValue: currentScore.value,
          onSelected: (value) => onScoreChange(value),
        ),
      ],
    );
  }
}
