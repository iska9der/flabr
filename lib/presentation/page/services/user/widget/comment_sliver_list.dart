import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../bloc/user/user_comment_list_cubit.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/comment/comment.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/scroll/scroll.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/comment/comment.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../../../../widget/user_text_button.dart';
import '../../../publications/publication_detail_page.dart';

class CommentSliverList extends StatelessWidget {
  const CommentSliverList({super.key, required this.fetch});

  final VoidCallback fetch;

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();
    const skeleton = _SkeletonLoader();

    return BlocConsumer<UserCommentListCubit, UserCommentListState>(
      listenWhen:
          (p, c) => p.page != 1 && c.status == CommentListStatus.failure,
      listener: (c, state) {
        context.showSnack(content: Text(state.error));
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
            return SliverFillRemaining(child: Center(child: Text(state.error)));
          }
        }

        var comments = state.comments;
        if (comments.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('Ничего нет')),
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
                      TextButton(
                        onPressed:
                            () => getIt<AppRouter>().pushWidget(
                              PublicationDetailPage(
                                type: model.publication.type.name,
                                id: model.publication.id,
                              ),
                            ),
                        child: Text(
                          model.publication.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Divider(thickness: 1),
                      UserTextButton(model.author),
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
            childCount:
                comments.length +
                (state.status == CommentListStatus.loading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  // ignore: unused_element_parameter
  const _SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverList.list(
        children:
            List.generate(
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
                    const UserTextButton(
                      PublicationAuthor(id: '0', alias: 'random alias'),
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
