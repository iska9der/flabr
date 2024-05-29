import 'package:flutter/material.dart';

import '../../model/sort/sort_option_model.dart';

class SortOptionsWidget extends StatelessWidget {
  const SortOptionsWidget({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    this.isEnabled = true,
  });

  final List<SortOptionModel> options;
  final dynamic currentValue;
  final ValueChanged<SortOptionModel> onSelected;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: options
            .map((option) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    label: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    selected: option.value == currentValue,
                    onSelected: (bool value) => onSelected(option),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
