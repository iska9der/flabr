import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widget/author_widget.dart';
import '../../../common/widget/comment_widget.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../cubit/user_comment_list_cubit.dart';

class CommentSliverList extends StatelessWidget {
  const CommentSliverList({super.key, required this.fetch});

  final VoidCallback fetch;

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();

    return BlocConsumer<UserCommentListCubit, UserCommentListState>(
      listenWhen: (p, c) =>
          p.page != 1 && c.status == CommentListStatus.failure,
      listener: (c, state) {
        getIt.get<Utils>().showSnack(
              context: context,
              content: Text(state.error),
            );
      },
      builder: (context, state) {
        /// Инициализация
        if (state.status == CommentListStatus.initial) {
          fetch();
          return const SliverFillRemaining(
            child: CircleIndicator(),
          );
        }

        /// Если происходит загрузка первой страницы
        if (context.read<UserCommentListCubit>().isFirstFetch) {
          if (state.status == CommentListStatus.loading) {
            return const SliverFillRemaining(
              child: CircleIndicator(),
            );
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

                return Padding(
                  padding: const EdgeInsets.all(fCardMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: AuthorWidget(model.author),
                      ),
                      ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: CommentWidget(model),
                      ),
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
