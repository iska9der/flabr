import 'package:flutter/material.dart';

import '../../../data/model/filter/filter.dart';

class FilterChipList extends StatelessWidget {
  const FilterChipList({
    super.key,
    this.isEnabled = true,
    required this.options,
    required this.onSelected,
    required this.isSelected,
  });

  final bool isEnabled;
  final List<FilterOption> options;
  final bool Function(FilterOption option) isSelected;
  final void Function(bool isSelected, FilterOption option) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children:
            options
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        option.label,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      selected: isSelected(option),
                      onSelected:
                          isEnabled
                              ? (bool value) => onSelected(value, option)
                              : null,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
