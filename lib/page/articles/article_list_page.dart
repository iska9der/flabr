import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/cubit/scroll_controller_cubit.dart';
import '../../common/utils/utils.dart';
import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/cubit/articles_cubit.dart';
import '../../feature/article/model/flow_enum.dart';
import '../../feature/article/model/sort/date_period_enum.dart';
import '../../feature/article/model/sort/rating_score_enum.dart';
import '../../feature/article/model/sort/sort_enum.dart';
import '../../feature/article/model/sort/sort_option_model.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/article/widget/article_card_widget.dart';
import '../../feature/article/widget/articles_sort_widget.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key, @QueryParam() String flow = 'all'})
      : super(key: key);

  static const String routeName = 'ArticleListRoute';
  static const String routePath = '';

  @override
  Widget build(BuildContext context) {
    /// remove line todo: - вывод параметров
    print(context.routeData.queryParams);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticlesService>(),
          )..fetchArticles(),
        ),
        BlocProvider(
          create: (c) => ScrollControllerCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const ArticleListPageView(),
    );
  }
}

class ArticleListPageView extends StatelessWidget {
  const ArticleListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ScrollControllerCubit>().state.controller;

    return BlocListener<ScrollControllerCubit, ScrollControllerState>(
      listener: (c, state) {
        if (state.isBottomEdge) {
          context.read<ArticlesCubit>().fetchArticles();
        }
      },
      child: Scaffold(
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * .6,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...FlowEnum.values
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
        floatingActionButton:
            BlocBuilder<ScrollControllerCubit, ScrollControllerState>(
          builder: (context, state) {
            return AnimatedOpacity(
              duration: context.read<ScrollControllerCubit>().duration,
              opacity: state.isTopEdge ? 0 : 1,
              child: FloatingActionButton(
                mini: true,
                onPressed: () =>
                    context.read<ScrollControllerCubit>().animateToTop(),
                child: const Icon(Icons.arrow_upward),
              ),
            );
          },
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              BlocBuilder<ArticlesCubit, ArticlesState>(
                builder: (context, state) {
                  return SliverAppBar(
                    title: Text(state.flow.label),
                  );
                },
              ),
              BlocBuilder<ArticlesCubit, ArticlesState>(
                builder: (context, state) {
                  return SliverAppBar(
                    automaticallyImplyLeading: false,
                    floating: true,
                    toolbarHeight: state.flow == FlowEnum.all ? 80 : 0,
                    title: state.flow == FlowEnum.all
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SortWidget(
                                isEnabled:
                                    state.status != ArticlesStatus.loading,
                                currentValue: state.sort,
                                onTap: (value) => context
                                    .read<ArticlesCubit>()
                                    .changeSort(value),
                              ),
                              SortOptionsWidget(
                                isEnabled:
                                    state.status != ArticlesStatus.loading,
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
                                    .changeSortOption(state.sort, value),
                              ),
                            ],
                          )
                        : null,
                  );
                },
              ),
              BlocConsumer<ArticlesCubit, ArticlesState>(
                listenWhen: (p, c) =>
                    p.page != 1 && c.status == ArticlesStatus.failure,
                listener: (c, state) {
                  getIt.get<Utils>().showNotification(
                        context: context,
                        content: Text(state.error),
                      );
                },
                builder: (context, state) {
                  if (context.read<ArticlesCubit>().isFirstFetch) {
                    if (state.status == ArticlesStatus.loading) {
                      return const SliverFillRemaining(
                        child: CircleIndicator(),
                      );
                    }
                    if (state.status == ArticlesStatus.failure) {
                      return SliverFillRemaining(
                        child: Center(child: Text(state.error)),
                      );
                    }
                  }

                  var articles = state.articles;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (c, i) {
                        if (i < articles.length) {
                          return ArticleCardWidget(article: articles[i]);
                        } else {
                          Timer(
                            const Duration(milliseconds: 30),
                            () => context
                                .read<ScrollControllerCubit>()
                                .animateToBottom(),
                          );

                          return const SizedBox(
                            height: 60,
                            child: CircleIndicator.medium(),
                          );
                        }
                      },
                      childCount: articles.length +
                          (state.status == ArticlesStatus.loading ? 1 : 0),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
