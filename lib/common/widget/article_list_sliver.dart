import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/di/dependencies.dart';
import '../../config/constants.dart';
import '../../feature/article/cubit/article_list_cubit.dart';
import '../../feature/article/widget/article_card_widget.dart';
import '../../feature/enhancement/scroll/cubit/scroll_cubit.dart';
import '../utils/utils.dart';
import 'enhancement/progress_indicator.dart';

class ArticleListSliver extends StatelessWidget {
  const ArticleListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();

    return BlocConsumer<ArticleListCubit, ArticleListState>(
      listenWhen: (p, c) => p.page != 1 && c.status == ArticlesStatus.failure,
      listener: (c, state) {
        getIt.get<Utils>().showNotification(
              context: context,
              content: Text(state.error),
            );
      },
      builder: (context, state) {
        /// Инициализация
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

          /// Ошибка при попытке получить статьи
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
