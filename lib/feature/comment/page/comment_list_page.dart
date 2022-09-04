import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/extension/color_x.dart';
import '../../../widget/progress_indicator.dart';
import '../../article/service/article_service.dart';
import '../../article/widget/article_author_widget.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../user/widget/user_avatar_widget.dart';
import '../cubit/comment_list_cubit.dart';
import '../model/comment_model.dart';

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
    return BlocProvider(
      create: (context) => CommentListCubit(
        articleId,
        service: getIt.get<ArticleService>(),
        langArticles: context.read<SettingsCubit>().state.langArticles,
        langUI: context.read<SettingsCubit>().state.langUI,
      ),
      child: const CommentListView(),
    );
  }
}

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(
                horizontal: kScreenHPadding,
              ),
              itemCount: comments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final comment = comments[index];

                return Column(
                  children: [
                    _buildTree(comment),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  _buildTree(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommentWidget(comment),
          for (comment in comment.children) _buildTree(comment)
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, {super.key});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i <= comment.level; i++)
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 12),
            child: Icon(
              i != comment.level ? Icons.circle_rounded : Icons.circle_outlined,
              size: 6,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusDefault),
                  color: comment.isPostAuthor
                      ? Colors.yellowAccent.withOpacity(.12)
                      : null,
                ),
                child: Row(
                  children: [
                    ArticleAuthorWidget(comment.author),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat.yMd().add_jm().format(comment.publishedAt),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              HtmlWidget(
                comment.message,
                key: ValueKey(Theme.of(context).brightness),
                customStylesBuilder: (element) {
                  if (element.localName == 'blockquote') {
                    return {
                      'margin': '12px',
                      'padding': '10px',
                      'background': Theme.of(context).backgroundColor.toHex(),
                    };
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
