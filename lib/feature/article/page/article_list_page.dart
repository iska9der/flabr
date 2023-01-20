import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/widget/profile_icon_button.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../search/cubit/search_cubit.dart';
import '../../search/model/search_delegate.dart';
import '../../search/repository/search_repository.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
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
            getIt.get<ArticleRepository>(),
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
            getIt.get<SearchRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
      ],
      child: const ArticleListPageView(),
    );
  }
}

class ArticleListPageView extends StatelessWidget {
  const ArticleListPageView({
    Key? key,
    this.type = ArticleType.article,
  }) : super(key: key);

  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<ArticleListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final controller = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        /// Если пользователь вошел, надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isAuthorized,
          listener: (context, state) {
            articlesCubit.refetch();
          },
        ),

        /// Если пользователь вышел
        ///
        /// к тому же он находится в потоке "Моя лента", то отправляем его
        /// на поток "Все", виджет сам стриггерит получение статей
        ///
        /// иначе переполучаем статьи напрямую
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isUnauthorized,
          listener: (context, state) {
            if (articlesCubit.state.flow == FlowEnum.feed) {
              return articlesCubit.changeFlow(FlowEnum.all);
            }

            articlesCubit.refetch();
          },
        ),

        /// Смена языков
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

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),
      ],
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * .6,
          child: SafeArea(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: FlowEnum.values.map((flow) {
                /// дергаем пункт "Моя лента"
                if (flow == FlowEnum.feed) {
                  final authState = context.watch<AuthCubit>().state;

                  /// если мы не в статьях и не авторизованы, то не показываем
                  /// этот пункт в drawer
                  if (type != ArticleType.article || !authState.isAuthorized) {
                    return const SizedBox();
                  }

                  return ListTile(
                    title: const Text('Моя лента'),
                    onTap: () {
                      articlesCubit.changeFlow(flow);

                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  return ListTile(
                    title: Text(flow.label),
                    onTap: () {
                      articlesCubit.changeFlow(flow);

                      Navigator.of(context).pop();
                    },
                  );
                }
              }).toList(),
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
                      if (type == ArticleType.article)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
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
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: MyProfileIconButton(),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ArticleListCubit, ArticleListState>(
                  builder: (context, state) {
                    if (state.flow == FlowEnum.feed) {
                      return const SliverToBoxAdapter();
                    }

                    return const SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      toolbarHeight: sortToolbarHeight,
                      title: ArticlesSortWidget(),
                    );
                  },
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

        if (articles.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Ничего нет'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) {
              if (i < articles.length) {
                final article = articles[i];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kScreenHPadding,
                  ),
                  child: ArticleCardWidget(article: article),
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
