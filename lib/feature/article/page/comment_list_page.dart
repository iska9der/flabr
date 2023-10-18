import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/app_expansion_panel.dart';
import '../../../widget/html_view_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/comment_hidden_cubit.dart';
import '../cubit/comment_list_cubit.dart';
import '../model/comment_model.dart';
import '../repository/article_repository.dart';
import '../widget/article_author_widget.dart';
import '../widget/comment/comment_rating_widget.dart';

const paddingBetweenTrees = 12.0;
const paddingBetweenChilds = 4.0;

@RoutePage(name: CommentListPage.routeName)
class CommentListPage extends StatelessWidget {
  const CommentListPage({
    super.key,
    @PathParam() required this.articleId,
  });

  final String articleId;

  static const routePath = 'comments/:articleId';
  static const routeName = 'ArticleCommentListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            articleId,
            repository: getIt.get<ArticleRepository>(),
            langArticles: context.read<SettingsCubit>().state.langArticles,
            langUI: context.read<SettingsCubit>().state.langUI,
          ),
        ),
        BlocProvider(create: (_) => CommentHiddenCubit()),
      ],
      child: const CommentListView(),
    );
  }
}

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Комментарии'),
      ),
      body: SafeArea(
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
                height: paddingBetweenTrees,
              ),
              itemBuilder: (context, index) {
                final comment = comments[index];

                return CommentTreeWidget(comment);
              },
            );
          },
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
                      padding: const EdgeInsets.only(top: paddingBetweenChilds),
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
