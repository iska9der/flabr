import 'package:flutter/material.dart';

import '../../../../../data/model/filter/part.dart';
import '../../../../widget/publication_filter_options_widget.dart';

class FeedFilterWidget extends StatelessWidget {
  const FeedFilterWidget({
    super.key,
    this.isLoading = false,
    required this.currentScore,
    required this.onScoreChange,
    required this.currentTypes,
    required this.onTypesChange,
  });

  final bool isLoading;

  final FilterOption currentScore;
  final Function(FilterOption score) onScoreChange;

  final List<FeedFilterPublication> currentTypes;
  final void Function(List<FeedFilterPublication> newTypes) onTypesChange;

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
          children: FeedFilterPublication.values
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
        PublicationFilterOptionsWidget(
          isEnabled: !isLoading,
          options: FilterList.scoreOptions,
          currentValue: currentScore,
          onSelected: (value) => onScoreChange(value),
        ),
      ],
    );
  }
}
