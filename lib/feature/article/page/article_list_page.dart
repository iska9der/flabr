import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../search/cubit/search_cubit.dart';
import '../../search/model/search_delegate.dart';
import '../../search/service/search_service.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_list_cubit.dart';
import '../model/flow_enum.dart';
import '../service/article_service.dart';
import '../widget/article_card_widget.dart';
import '../widget/sort/articles_sort_widget.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key, @PathParam() required this.flow})
      : super(key: key);

  final String flow;

  static const String name = 'Статьи';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleService>(),
            flow: FlowEnum.fromString(flow),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
        BlocProvider(
          create: (c) => SearchCubit(
            getIt.get<SearchService>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
      ],
      child: const ArticleListPageView(isSearchEnabled: true),
    );
  }
}

class ArticleListPageView extends StatelessWidget {
  const ArticleListPageView({
    Key? key,
    this.isSearchEnabled = false,
  }) : super(key: key);

  final bool isSearchEnabled;

  @override
  Widget build(BuildContext context) {
    var articlesCubit = context.read<ArticleListCubit>();
    var scrollCubit = context.read<ScrollCubit>();
    var controller = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
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
              cacheExtent: 1000,
              controller: controller,
              slivers: [
                BlocBuilder<ArticleListCubit, ArticleListState>(
                  builder: (context, state) => SliverAppBar(
                    title: Text(state.flow.label),
                    actions: [
                      if (isSearchEnabled)
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            onPressed: () async {
                              final cubit = context.read<SearchCubit>();

                              await showSearch(
                                context: context,
                                delegate: FlabrSearchDelegate(
                                  cubit: BlocProvider.of<SearchCubit>(context),
                                ),
                              );

                              cubit.reset();
                            },
                            icon: const Icon(Icons.search_rounded),
                          ),
                        ),
                    ],
                  ),
                ),
                const SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: sortToolbarHeight,
                  title: ArticlesSortWidget(),
                ),

                /// Статьи
                const ArticleSliverList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleSliverList extends StatelessWidget {
  const ArticleSliverList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticleListCubit, ArticleListState>(
      listenWhen: (p, c) => p.page != 1 && c.status == ArticlesStatus.failure,
      listener: (c, state) {
        getIt.get<Utils>().showNotification(
              context: context,
              content: Text(state.error),
            );
      },
      builder: (context, state) {
        final ScrollCubit? scrollCubit = context.read<ScrollCubit?>();

        if (state.status == ArticlesStatus.initial) {
          context.read<ArticleListCubit>().fetch();

          return const SliverFillRemaining(
            child: CircleIndicator(),
          );
        }

        /// Если происходит загрузка первой страницы
        if (context.read<ArticleListCubit>().isFirstFetch) {
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
                scrollCubit?.duration ?? const Duration(milliseconds: 30),
                () => scrollCubit?.animateToBottom(),
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
    );
  }
}
