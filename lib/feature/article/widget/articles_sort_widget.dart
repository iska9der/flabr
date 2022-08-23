import 'package:flutter/material.dart';

import '../../../config/constants.dart';
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
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: SortEnum.values.map((type) {
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isEnabled ? () => onTap(type) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: currentValue == type
                        ? Theme.of(context).focusColor
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: Text(type.label, textAlign: TextAlign.center),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SortOptionsWidget extends StatelessWidget {
  const SortOptionsWidget({
    Key? key,
    required this.currentValue,
    required this.options,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  final dynamic currentValue;
  final ValueChanged<SortOptionModel> onTap;
  final List<SortOptionModel> options;

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options
            .map(
              (option) => Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEnabled ? () => onTap(option) : null,
                    splashColor: Theme.of(context).splashColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentValue == option.value
                            ? Theme.of(context).focusColor
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        option.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
