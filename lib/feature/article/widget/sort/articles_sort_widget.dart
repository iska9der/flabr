import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/article_list_cubit.dart';
import '../../model/sort/date_period_enum.dart';
import '../../model/sort/rating_score_enum.dart';
import '../../model/sort/sort_enum.dart';
import '../../model/sort/sort_option_model.dart';

part 'sort_by_widget.dart';
part 'sort_options_widget.dart';

class ArticlesSortWidget extends StatelessWidget {
  const ArticlesSortWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<ArticleListCubit>();

    return BlocBuilder<ArticleListCubit, ArticleListState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _SortByWidget(
              isEnabled: state.status != ArticlesStatus.loading,
              currentValue: state.sort,
              onTap: (sort) => articlesCubit.changeSort(sort),
            ),
            _SortOptionsWidget(
              isEnabled: state.status != ArticlesStatus.loading,
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