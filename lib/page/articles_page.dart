import 'package:flabr/common/widget/progress_indicator.dart';
import 'package:flabr/feature/article/model/article_type.dart';
import 'package:flabr/feature/article/model/sort/date_period_enum.dart';
import 'package:flabr/feature/article/model/sort/rating_score_enum.dart';
import 'package:flabr/feature/article/model/sort/sort_option_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/di/dependencies.dart';
import '../feature/article/cubit/articles_cubit.dart';
import '../feature/article/model/sort/sort_enum.dart';
import '../feature/article/service/article_service.dart';
import '../feature/article/widget/article_card_widget.dart';
import '../feature/article/widget/sort_widget.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ArticlesCubit(
        getIt.get<ArticleService>(),
      )..fetchArticles(),
      child: const ArticlesView(),
    );
  }
}

class ArticlesView extends StatelessWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .6,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ...ArticleType.values
                .map((type) => ListTile(
                      title: Text(type.label),
                      onTap: () {
                        context.read<ArticlesCubit>().changeType(type);

                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ArticlesCubit, ArticlesState>(
              builder: (context, state) {
                return SliverAppBar(
                  title: Text(state.type.label),
                  floating: true,
                  automaticallyImplyLeading: true,
                  expandedHeight: state.type == ArticleType.all ? 130 : null,
                  flexibleSpace: state.type == ArticleType.all
                      ? FlexibleSpaceBar(
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SortWidget(
                                currentValue: state.sort,
                                onTap: (value) => context
                                    .read<ArticlesCubit>()
                                    .changeSort(value),
                              ),
                              SortOptionsWidget(
                                options: state.sort == SortEnum.date
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
                                        .toList(),
                                currentValue: state.sort == SortEnum.date
                                    ? state.period
                                    : state.score,
                                onTap: (value) => context
                                    .read<ArticlesCubit>()
                                    .changeVariant(state.sort, value),
                              ),
                            ],
                          ),
                        )
                      : null,
                );
              },
            ),
            BlocConsumer<ArticlesCubit, ArticlesState>(
              listenWhen: (p, c) =>
                  c.status == ArticlesStatus.error && c.error.isNotEmpty,
              listener: (c, s) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.error)),
                );
              },
              builder: (context, state) {
                if (state.status == ArticlesStatus.loading) {
                  return const SliverFillRemaining(
                    child: CircleIndicator(),
                  );
                }

                var articles = state.articles;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (c, i) => ArticleCardWidget(article: articles[i]),
                    childCount: articles.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
