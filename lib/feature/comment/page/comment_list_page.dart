import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/stat_type.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/app_expansion_panel.dart';
import '../../../widget/html_view_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../../../widget/stat_text_widget.dart';
import '../../article/repository/article_repository.dart';
import '../../article/widget/article_author_widget.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/comment_hidden_cubit.dart';
import '../cubit/comment_list_cubit.dart';
import '../model/comment_model.dart';

const paddingBetweenTrees = 44.0;
const paddingBetweenChilds = 22.0;

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
          create: (c) => CommentListCubit(
            articleId,
            repository: getIt.get<ArticleRepository>(),
            langArticles: context.read<SettingsCubit>().state.langArticles,
            langUI: context.read<SettingsCubit>().state.langUI,
          ),
        ),
        BlocProvider(
          create: (c) => CommentHiddenCubit(),
        ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: kScreenHPadding,
                vertical: kScreenHPadding * 0.5,
              ),
              separatorBuilder: (c, i) => const Divider(
                height: paddingBetweenTrees,
              ),
              itemBuilder: (context, index) {
                final comment = comments[index];
                bool isLast = index + 1 == comments.length;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? paddingBetweenTrees : 0,
                  ),
                  child: CommentTreeWidget(comment),
                );
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
              isExpanded: !state.hiddenComments.contains(comment.id),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconBuilder: (child, isExpanded) {
                return ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(kBorderRadiusDefault),
                    bottomRight: Radius.circular(kBorderRadiusDefault),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: comment.isPostAuthor
                          ? Colors.yellowAccent.withOpacity(.12)
                          : Theme.of(context).colorScheme.surface,
                    ),
                    child: child,
                  ),
                );
              },
              headerBuilder: (context, isExpanded) {
                return ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kBorderRadiusDefault),
                    bottomLeft: Radius.circular(kBorderRadiusDefault),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: comment.isPostAuthor
                          ? Colors.yellowAccent.withOpacity(.12)
                          : Theme.of(context).colorScheme.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          /// Автор
                          ArticleAuthorWidget(comment.author),

                          /// Заполняем пространство между виджетами
                          const Expanded(child: Wrap()),

                          /// Очки
                          StatTextWidget(
                            type: StatType.score,
                            value: comment.score,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommentWidget(comment),
                  ),
                  for (var child in comment.children)
                    Padding(
                      padding: const EdgeInsets.only(top: paddingBetweenChilds),
                      child: CommentTreeWidget(child),
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
    const textPadding = 4.0;
    final paddingLeft = 6.0 * comment.level;

    return Padding(
      padding: EdgeInsets.only(left: paddingLeft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Дата коммента
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: textPadding,
              vertical: textPadding * 1.5,
            ),
            child: Text(
              DateFormat.yMd().add_jm().format(comment.publishedAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          /// Текст
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: textPadding),
            child: HtmlView(
              textHtml: comment.message,
              renderMode: RenderMode.column,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
