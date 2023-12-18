import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../publication/cubit/publication_list_cubit.dart';
import '../../../publication/model/sort/date_period_enum.dart';
import '../../../publication/model/sort/rating_score_enum.dart';
import '../../../publication/model/sort/sort_enum.dart';
import '../../../publication/model/sort/sort_option_model.dart';

part 'sort_by_widget.dart';
part 'sort_options_widget.dart';

class ArticlesSortWidget extends StatelessWidget {
  const ArticlesSortWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<PublicationListCubit>();

    return BlocBuilder<PublicationListCubit, PublicationListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SortByWidget(
              isEnabled: state.status != PublicationListStatus.loading,
              currentValue: state.sort,
              onTap: (sort) => articlesCubit.changeSort(sort),
            ),
            _SortOptionsWidget(
              isEnabled: state.status != PublicationListStatus.loading,
              currentSort: state.sort,
              currentValue:
                  state.sort == SortEnum.byBest ? state.period : state.score,
              onTap: (option) => articlesCubit.changeSortOption(
                state.sort,
                option,
              ),
            ),
          ],
        );
      },
    );
  }
}
