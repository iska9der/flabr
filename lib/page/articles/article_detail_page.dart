import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/widget/html_view_widget.dart';
import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/cubit/article_cubit.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/article/widget/article_card_widget.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    Key? key,
    @PathParam() required this.id,
  }) : super(key: key);

  final String id;

  static const String routePath = ':id';
  static const String routeName = 'ArticleDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ArticleCubit(
        id,
        service: getIt.get<ArticlesService>(),
      )..fetch(),
      child: const ArticleDetailPageView(),
    );
  }
}

class ArticleDetailPageView extends StatelessWidget {
  const ArticleDetailPageView({Key? key}) : super(key: key);

  static const hPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ArticleCubit, ArticleState>(
          builder: (context, state) {
            if (state.status == ArticleStatus.loading) {
              return const CircleIndicator();
            }
            if (state.status == ArticleStatus.failure) {
              return Center(child: Text(state.error));
            }

            final article = state.article;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  toolbarHeight: 40,
                  titleSpacing: 0,
                  title: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    expandedTitleScale: 1,
                    title: Row(
                      children: [
                        const AutoLeadingButton(),
                        Expanded(
                          child: Text(
                            article.titleHtml,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: hPadding,
                      vertical: 16.0,
                    ),
                    child: ArticleTopRow(article),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: hPadding,
                      right: hPadding,
                      bottom: hPadding,
                    ),
                    child: SelectableText(
                      article.titleHtml,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                HtmlView(textHtml: article.textHtml),
              ],
            );
          },
        ),
      ),
    );
  }
}
