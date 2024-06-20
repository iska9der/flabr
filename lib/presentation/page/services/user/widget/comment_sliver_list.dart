import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/comment/comment_model.dart';
import '../../../../../data/model/publication/publication_author_model.dart';
import '../../../../feature/scroll/part.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/author_widget.dart';
import '../../../../widget/comment/comment_widget.dart';
import '../../../../widget/enhancement/button.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../../../publications/articles/article_detail_page.dart';
import '../cubit/user_comment_list_cubit.dart';

class CommentSliverList extends StatelessWidget {
  const CommentSliverList({super.key, required this.fetch});

  final VoidCallback fetch;

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();
    const skeleton = _SkeletonLoader();

    return BlocConsumer<UserCommentListCubit, UserCommentListState>(
      listenWhen: (p, c) =>
          p.page != 1 && c.status == CommentListStatus.failure,
      listener: (c, state) {
        getIt<Utils>().showSnack(
          context: context,
          content: Text(state.error),
        );
      },
      builder: (context, state) {
        /// Инициализация
        if (state.status == CommentListStatus.initial) {
          fetch();

          return skeleton;
        }

        /// Если происходит загрузка первой страницы
        if (state.isFirstFetch) {
          if (state.status == CommentListStatus.loading) {
            return skeleton;
          }

          /// Ошибка при попытке получить статьи
          if (state.status == CommentListStatus.failure) {
            return SliverFillRemaining(
              child: Center(child: Text(state.error)),
            );
          }
        }

        var comments = state.comments;
        if (comments.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Ничего нет'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) {
              if (i < comments.length) {
                final model = comments[i];

                return FlabrCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlabrTextButton.rectangle(
                        onPressed: () => getIt<AppRouter>().pushWidget(
                          ArticleDetailPage(id: model.publication.id),
                        ),
                        child: Text(
                          model.publication.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Divider(thickness: 1),
                      AuthorWidget(model.author),
                      CommentWidget(model),
                    ],
                  ),
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
            childCount: comments.length +
                (state.status == CommentListStatus.loading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  // ignore: unused_element
  const _SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverList.list(
        children: List.generate(
          4,
          (i) => FlabrCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Some random title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(thickness: 1),
                const AuthorWidget(
                  PublicationAuthor(
                    id: '0',
                    alias: 'random alias',
                  ),
                ),
                const CommentWidget(
                  Comment(
                    id: '0',
                    message: 'Some random message with some random text...',
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }
}
