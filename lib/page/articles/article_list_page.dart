import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/utils.dart';
import '../../config/constants.dart';
import '../../feature/scroll/cubit/scroll_controller_cubit.dart';
import '../../feature/scroll/widget/floating_scroll_to_top_button.dart';
import '../../widget/progress_indicator.dart';
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
import '../../feature/settings/cubit/settings_cubit.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key, @PathParam() required this.flow})
      : super(key: key);

  final String flow;

  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticlesService>(),
            flow: FlowEnum.fromString(flow),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
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
    var articlesCubit = context.read<ArticlesCubit>();
    var scrollCubit = context.read<ScrollControllerCubit>();
    var controller = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollControllerCubit, ScrollControllerState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetchArticles(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (p, c) =>
              p.langUI != c.langUI || p.langArticles != c.langArticles,
          listener: (context, state) {
            articlesCubit.changeLanguage(
              langUI: state.langUI,
              langArticles: state.langArticles,
            );

            scrollCubit.animateToTop();
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * .6,
          child: SafeArea(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ...FlowEnum.values
                    .map((type) => ListTile(
                          title: Text(type.label),
                          onTap: () {
                            articlesCubit.changeFlow(type);

                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Scrollbar(
            controller: controller,
            child: CustomScrollView(
              controller: controller,
              slivers: [
                BlocBuilder<ArticlesCubit, ArticlesState>(
                  builder: (context, state) => SliverAppBar(
                    title: Text(state.flow.label),
                  ),
                ),
                BlocBuilder<ArticlesCubit, ArticlesState>(
                  builder: (context, state) {
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      toolbarHeight: 80,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SortWidget(
                            isEnabled: state.status != ArticlesStatus.loading,
                            currentValue: state.sort,
                            onTap: (value) => articlesCubit.changeSort(value),
                          ),
                          SortOptionsWidget(
                            isEnabled: state.status != ArticlesStatus.loading,
                            options: state.sort == SortEnum.byBest
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
                            currentValue: state.sort == SortEnum.byBest
                                ? state.period
                                : state.score,
                            onTap: (value) => articlesCubit.changeSortOption(
                              state.sort,
                              value,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                /// Список новостей
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
                    if (state.status == ArticlesStatus.initial) {
                      articlesCubit.fetchArticles();

                      return const SliverFillRemaining(
                        child: CircleIndicator(),
                      );
                    }

                    /// Если происходит загрузка первой страницы
                    if (articlesCubit.isFirstFetch) {
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kScreenHPadding,
                              ),
                              child: ArticleCardWidget(article: articles[i]),
                            );
                          }

                          Timer(
                            const Duration(milliseconds: 30),
                            () => scrollCubit.animateToBottom(),
                          );

                          return const SizedBox(
                            height: 60,
                            child: CircleIndicator.medium(),
                          );
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
      ),
    );
  }
}
