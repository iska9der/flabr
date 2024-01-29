part of 'publication_sort_widget.dart';

class _SortOptionsWidget extends StatelessWidget {
  const _SortOptionsWidget({
    required this.currentSort,
    required this.currentValue,
    required this.onTap,
    this.isEnabled = true,
  });

  final SortEnum currentSort;
  final dynamic currentValue;
  final ValueChanged<SortOptionModel> onTap;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final options = switch (currentSort) {
      SortEnum.byNew => RatingScoreEnum.values
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
    };

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
                    onSelected: (bool value) => onTap(option),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
