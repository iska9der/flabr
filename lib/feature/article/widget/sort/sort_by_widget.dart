part of 'articles_sort_widget.dart';

class _SortByWidget extends StatelessWidget {
  const _SortByWidget({
    required this.currentValue,
    required this.onTap,
    this.isEnabled = true,
  });

  final SortEnum currentValue;
  final ValueChanged<SortEnum> onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: SortEnum.values
          .map((sort) => ChoiceChip(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                label: Text(
                  sort.label,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                selected: sort == currentValue,
                onSelected: (bool value) => onTap(sort),
              ))
          .toList(),
    );
  }
}
