import 'package:auto_route/annotations.dart';
import 'package:flabr/common/widget/progress_indicator.dart';
import 'package:flabr/components/di/dependencies.dart';
import 'package:flabr/feature/article/cubit/article_cubit.dart';
import 'package:flabr/feature/article/service/article_service.dart';
import 'package:flabr/feature/article/widget/article_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    Key? key,
    @PathParam() required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleCubit(
        id,
        service: getIt.get<ArticleService>(),
      )..fetch(),
      child: const Scaffold(
        body: SafeArea(child: ArticleView()),
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({Key? key}) : super(key: key);

  static const hPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
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
                title: Text(
              article.titleHtml,
              style: const TextStyle(fontSize: 14),
            )),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: hPadding,
                    vertical: 16.0,
                  ),
                  child: ArticleAuthorWidget(article),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: hPadding,
                    right: hPadding,
                    bottom: hPadding,
                  ),
                  child: Text(
                    article.titleHtml,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: hPadding),
                  child: Text(article.textHtml),
                )
              ]),
            ),
          ],
        );
      },
    );
  }
}
