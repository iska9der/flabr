import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/utils.dart';
import '../../config/constants.dart';
import '../../feature/scroll/cubit/scroll_controller_cubit.dart';
import '../../feature/scroll/widget/floating_scroll_to_top_button.dart';
import '../../widget/card_widget.dart';
import '../../widget/progress_indicator.dart';
import '../../feature/article/cubit/articles_cubit.dart';
import '../../feature/article/model/article_model.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/settings/cubit/settings_cubit.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({Key? key}) : super(key: key);

  static const String routePath = '';
  static const String routeName = 'NewsListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticlesService>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollControllerCubit()..setUpEdgeListeners(),
        ),
      ],
      child: Builder(
        builder: (context) {
          var articlesCubit = context.read<ArticlesCubit>();

          return MultiBlocListener(
            listeners: [
              BlocListener<ScrollControllerCubit, ScrollControllerState>(
                listenWhen: (p, c) => c.isBottomEdge,
                listener: (context, state) => articlesCubit.fetchNews(),
              ),
              BlocListener<SettingsCubit, SettingsState>(
                listenWhen: (p, c) =>
                    p.langUI != c.langUI || p.langArticles != c.langArticles,
                listener: (context, state) {
                  articlesCubit.changeLanguage(
                    langUI: state.langUI,
                    langArticles: state.langArticles,
                  );
                },
              ),
              BlocListener<ArticlesCubit, ArticlesState>(
                listenWhen: (p, c) =>
                    c.status == ArticlesStatus.failure && c.error.isNotEmpty,
                listener: (c, state) {
                  getIt.get<Utils>().showNotification(
                        context: context,
                        content: Text(state.error),
                      );
                },
              ),
            ],
            child: const NewsListPageView(),
          );
        },
      ),
    );
  }
}

class NewsListPageView extends StatelessWidget {
  const NewsListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollCubit = context.read<ScrollControllerCubit>();
    var scrollCtrl = scrollCubit.state.controller;

    return Scaffold(
      floatingActionButton: const FloatingScrollToTopButton(),
      body: SafeArea(
        child: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state.status == ArticlesStatus.initial) {
              context.read<ArticlesCubit>().fetchNews();

              return const CircleIndicator();
            }

            if (state.status == ArticlesStatus.loading &&
                context.read<ArticlesCubit>().isFirstFetch) {
              return const CircleIndicator();
            }

            var news = state.articles;

            return ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(
                horizontal: kScreenHPadding,
              ),
              itemCount: news.length +
                  (state.status == ArticlesStatus.loading ? 1 : 0),
              itemBuilder: (c, i) {
                if (i < news.length) {
                  return _Card(article: news[i]);
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
            );
          },
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      padding: const EdgeInsets.all(8.0),
      child: Text(article.titleHtml),
    );
  }
}
