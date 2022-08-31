part of 'articles_sort_widget.dart';

class _SortOptionsWidget extends StatelessWidget {
  const _SortOptionsWidget({
    Key? key,
    required this.currentSort,
    required this.currentValue,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  final SortEnum currentSort;
  final dynamic currentValue;
  final ValueChanged<SortOptionModel> onTap;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final List<SortOptionModel> options = currentSort == SortEnum.byBest
        ? DatePeriodEnum.values
            .map((period) => SortOptionModel(
                  label: period.label,
                  value: period,
                ))
            .toList()
        : RatingScoreEnum.values
            .map((score) => SortOptionModel(
                  label: score.label,
                  value: score.value,
                ))
            .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options
          .map((option) => ChoiceChip(
                visualDensity: VisualDensity.compact,
                label: Text(
                  option.label,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                selected: option.value == currentValue,
                onSelected: (bool value) => onTap(option),
              ))
          .toList(),
    );
  }
}
