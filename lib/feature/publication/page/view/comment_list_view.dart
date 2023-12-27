import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/model/extension/enum_status.dart';
import '../../../../common/widget/author_widget.dart';
import '../../../../common/widget/comment_widget.dart';
import '../../../../common/widget/enhancement/app_expansion_panel.dart';
import '../../../../common/widget/enhancement/progress_indicator.dart';
import '../../cubit/comment/comment_hidden_cubit.dart';
import '../../cubit/comment/comment_list_cubit.dart';
import '../../model/comment/comment_model.dart';

const _paddingBetweenTrees = 12.0;
const _paddingBetweenChilds = 4.0;

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Комментарии'),
      ),
      body: SafeArea(
        child: SelectionArea(
          child: BlocBuilder<CommentListCubit, CommentListState>(
            builder: (context, state) {
              if (state.status.isInitial) {
                context.read<CommentListCubit>().fetch();
                return const CircleIndicator();
              }

              if (state.status.isLoading) {
                return const CircleIndicator();
              }

              if (state.status.isFailure) {
                return Center(child: Text(state.error));
              }

              final comments = state.list.comments;
              if (comments.isEmpty) {
                return const Center(
                  child: Text('Нет комментариев'),
                );
              }

              return ListView.separated(
                itemCount: comments.length,
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                separatorBuilder: (c, i) => const SizedBox(
                  height: _paddingBetweenTrees,
                ),
                itemBuilder: (context, index) {
                  final comment = comments[index];

                  return CommentTreeWidget(comment);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Рекурсивный виджет для отрисовки дерева комментариев
class CommentTreeWidget extends StatelessWidget {
  const CommentTreeWidget(this.comment, {super.key});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    final authorColor = comment.isPostAuthor
        ? Colors.yellowAccent.withOpacity(.12)
        : Theme.of(context).colorScheme.surface;

    return BlocBuilder<CommentHiddenCubit, CommentHiddenState>(
      builder: (context, state) {
        return AppExpansionPanelList(
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            context.read<CommentHiddenCubit>().setIsHidden(
                  comment.id,
                  isExpanded,
                );
          },
          children: [
            AppExpansionPanel(
              isExpanded: !state.isHidden(comment.id),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconBuilder: (child, isExpanded) {
                return ColoredBox(
                  color: authorColor,
                  child: child,
                );
              },
              headerBuilder: (context, isExpanded) {
                return ColoredBox(
                  color: authorColor,
                  child: AuthorWidget(comment.author),
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CommentWidget(comment),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comment.children.length,
                    itemBuilder: (_, i) => Padding(
                      padding:
                          const EdgeInsets.only(top: _paddingBetweenChilds),
                      child: CommentTreeWidget(comment.children[i]),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CommentWidget extends StatelessWidget {
  // ignore: unused_element
  const _CommentWidget(this.comment, {super.key});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    final bgColor = comment.isPostAuthor
        ? Colors.yellowAccent.withOpacity(.12)
        : Theme.of(context).colorScheme.surface;

    return ColoredBox(
      color: bgColor,
      child: CommentWidget(comment),
    );
  }
}
