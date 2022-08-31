import 'package:flutter/material.dart';

import '../model/sort/date_period_enum.dart';
import '../model/sort/rating_score_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';

class SortWidget extends StatelessWidget {
  const SortWidget({
    Key? key,
    required this.currentValue,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  final SortEnum currentValue;
  final ValueChanged<SortEnum> onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: SortEnum.values
          .map((sort) => ChoiceChip(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                label: SizedBox(
                  width: MediaQuery.of(context).size.width * .35,
                  child: Text(
                    sort.label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: sort == currentValue,
                onSelected: (bool value) => onTap(sort),
              ))
          .toList(),
    );
  }
}

class SortOptionsWidget extends StatelessWidget {
  const SortOptionsWidget({
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
      // .map((option) => Expanded(
      //       child: Material(
      //         color: Colors.transparent,
      //         child: InkWell(
      //           onTap: isEnabled ? () => onTap(option) : null,
      //           splashColor: Theme.of(context).splashColor,
      //           child: Container(
      //             decoration: BoxDecoration(
      //               color: currentValue == option.value
      //                   ? Theme.of(context).focusColor
      //                   : null,
      //             ),
      //             padding: const EdgeInsets.symmetric(vertical: 6),
      //             child: Text(
      //               option.label,
      //               textAlign: TextAlign.center,
      //               style: Theme.of(context).textTheme.caption,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ))
      // .toList(),
    );
  }
}
