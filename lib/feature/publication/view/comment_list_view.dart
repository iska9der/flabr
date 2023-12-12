import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/widget/enhancement/app_expansion_panel.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../common/widget/html_view_widget.dart';
import '../../../config/constants.dart';
import '../../article/cubit/comment_hidden_cubit.dart';
import '../../article/cubit/comment_list_cubit.dart';
import '../../article/widget/article_author_widget.dart';
import '../../article/widget/comment/comment_rating_widget.dart';
import '../model/comment/comment_model.dart';

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
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: authorColor,
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(kBorderRadiusDefault),
                      bottomRight: !isExpanded
                          ? const Radius.circular(kBorderRadiusDefault)
                          : Radius.zero,
                    ),
                  ),
                  child: child,
                );
              },
              headerBuilder: (context, isExpanded) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: authorColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(kBorderRadiusDefault),
                      bottomLeft: !isExpanded
                          ? const Radius.circular(kBorderRadiusDefault)
                          : Radius.zero,
                    ),
                  ),
                  child: ArticleAuthorWidget(comment.author),
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommentWidget(comment),
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

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, {super.key});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    const basePadding = 10.0;
    final additional = comment.level == 0 ? 0 : comment.level + 6;
    final paddingLeft = basePadding + additional;
    final bgColor = comment.isPostAuthor
        ? Colors.yellowAccent.withOpacity(.12)
        : Theme.of(context).colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(kBorderRadiusDefault),
          bottomLeft: Radius.circular(kBorderRadiusDefault),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Текст
          Padding(
            padding: EdgeInsets.only(left: paddingLeft, right: basePadding),
            child: HtmlView(
              textHtml: comment.message,
              renderMode: RenderMode.column,
              padding: EdgeInsets.zero,
            ),
          ),

          /// Футер
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: basePadding,
              vertical: basePadding,
            ),
            child: Row(
              children: [
                CommentRatingWidget(comment),
                const Spacer(),
                Text(
                  DateFormat.yMd().add_jm().format(comment.publishedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
