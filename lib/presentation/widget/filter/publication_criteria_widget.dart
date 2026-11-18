import 'package:flutter/material.dart';

import '../../../data/model/filter/filter.dart';
import '../../../data/model/publication/publication.dart';
import '../../../i18n/i18n.dart';
import 'filter_chip_list.dart';

class PublicationCriteriaWidget extends StatelessWidget {
  const PublicationCriteriaWidget({
    super.key,
    required this.criteria,
    required this.isEnabled,
    required this.onChanged,
  });

  final PublicationCriteria criteria;
  final bool isEnabled;
  final ValueChanged<PublicationCriteria> onChanged;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final allFormats =
        criteria.formats.length == PublicationFormat.values.length;
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Text(context.t.filter.complexity, style: titleStyle),
        FilterChipList(
          isEnabled: isEnabled,
          options: [
            FilterOption(label: context.t.filter.all, value: ''),
            for (final level in PublicationComplexity.values)
              FilterOption(label: level.label, value: level.name),
          ],
          isSelected: (option) =>
              option.value == (criteria.complexity?.name ?? ''),
          onSelected: (_, option) => onChanged(
            criteria.copyWith(
              complexity: option.value.isEmpty
                  ? null
                  : PublicationComplexity.values.byName(option.value),
            ),
          ),
        ),
        Text(context.t.filter.format, style: titleStyle),
        FilterChipList(
          isEnabled: isEnabled,
          options: [
            FilterOption(label: context.t.filter.all, value: ''),
            for (final format in PublicationFormat.values)
              FilterOption(label: format.label, value: format.name),
          ],
          isSelected: (option) => option.value.isEmpty
              ? allFormats
              : criteria.formats.contains(
                  PublicationFormat.values.byName(option.value),
                ),
          onSelected: (selected, option) {
            if (option.value.isEmpty) {
              onChanged(
                criteria.copyWith(
                  formats: selected ? PublicationFormat.values : [],
                ),
              );
              return;
            }
            final format = PublicationFormat.values.byName(option.value);
            final formats = [...criteria.formats];
            if (selected) {
              formats.add(format);
            } else {
              formats.remove(format);
            }
            onChanged(criteria.copyWith(formats: formats));
          },
        ),
      ],
    );
  }
}
