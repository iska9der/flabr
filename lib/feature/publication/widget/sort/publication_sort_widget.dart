import 'package:flutter/material.dart';

import '../../../publication/model/sort/date_period_enum.dart';
import '../../../publication/model/sort/rating_score_enum.dart';
import '../../../publication/model/sort/sort_enum.dart';
import '../../../publication/model/sort/sort_option_model.dart';

part 'sort_by_widget.dart';
part 'sort_options_widget.dart';

class PublicationSortWidget extends StatelessWidget {
  const PublicationSortWidget({
    super.key,
    required this.sortValue,
    required this.sortChange,
    required this.optionValue,
    required this.optionChange,
    this.isLoading = false,
  });

  final bool isLoading;
  final SortEnum sortValue;
  final Function(SortEnum sort) sortChange;

  final dynamic optionValue;
  final Function(SortOptionModel option) optionChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SortByWidget(
          isEnabled: !isLoading,
          currentValue: sortValue,
          onTap: (sort) => sortChange(sort),
        ),
        _SortOptionsWidget(
          isEnabled: !isLoading,
          currentSort: sortValue,
          currentValue: optionValue,
          onTap: (option) => optionChange(option),
        ),
      ],
    );
  }
}
