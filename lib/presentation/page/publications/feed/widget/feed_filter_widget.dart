import 'package:flutter/material.dart';

import '../../../../../data/model/filter/part.dart';
import '../../../../widget/filter/publication_filter_options_widget.dart';
import '../../../../widget/filter/publication_filter_submit_button.dart';

class FeedFilterWidget extends StatefulWidget {
  const FeedFilterWidget({
    super.key,
    this.isLoading = false,
    required this.currentScore,
    required this.currentTypes,
    required this.onSubmit,
  });

  final bool isLoading;

  final FilterOption currentScore;

  final List<FeedFilterPublication> currentTypes;
  final Function(FeedFilter filter) onSubmit;

  @override
  State<FeedFilterWidget> createState() => _FeedFilterWidgetState();
}

class _FeedFilterWidgetState extends State<FeedFilterWidget> {
  late FilterOption scoreValue = widget.currentScore;
  late List<FeedFilterPublication> typesValue = widget.currentTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Тип публикации',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        PublicationFilterOptionsWidget(
          isEnabled: !widget.isLoading,
          options: FeedFilterPublication.values
              .map((e) => FilterOption(label: e.label, value: e.name))
              .toList(),
          isSelected: (option) => typesValue
              .contains(FeedFilterPublication.fromString(option.value)),
          onSelected: (isSelected, newOption) {
            final newType = FeedFilterPublication.fromString(newOption.value);

            List<FeedFilterPublication> newTypes;
            if (isSelected) {
              newTypes = [...typesValue, newType];
            } else {
              newTypes = [...typesValue]
                ..removeWhere((element) => element == newType);
            }

            if (newTypes.isEmpty) {
              return;
            }

            setState(() {
              typesValue = newTypes;
            });
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Порог рейтинга',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        PublicationFilterOptionsWidget(
          isEnabled: !widget.isLoading,
          options: FilterList.scoreOptions,
          isSelected: (option) => option == scoreValue,
          onSelected: (isSelected, option) => setState(() {
            scoreValue = option;
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PublicationFilterSubmitButton(
            isEnabled: !widget.isLoading,
            onSubmit: () => widget.onSubmit(FeedFilter(
              score: scoreValue,
              types: typesValue,
            )),
          ),
        ),
      ],
    );
  }
}
