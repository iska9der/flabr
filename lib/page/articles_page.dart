import 'package:auto_route/auto_route.dart';
import 'package:flabr/common/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../components/di/dependencies.dart';
import '../feature/article/cubit/articles_cubit.dart';
import '../feature/article/model/article_model.dart';
import '../feature/article/service/article_service.dart';

class ArticlesRoute extends PageRouteInfo {
  const ArticlesRoute() : super(name, path: '/article/');

  static const String name = 'ArticlesRoute';
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticleService>(),
          )..fetchAll(),
          child: const ArticlesView(),
        ),
      ),
    );
  }
}

class ArticlesView extends StatelessWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticlesCubit, ArticlesState>(
      listenWhen: (p, c) =>
          c.status == ArticlesStatus.error && c.error.isNotEmpty,
      listener: (c, s) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.error)),
        );
      },
      builder: (context, state) {
        if (state.status == ArticlesStatus.loading) {
          return const CircleIndicator();
        }

        var articles = state.articles;

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (c, i) {
            return _Card(article: articles[i]);
          },
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final timePub = DateFormat.yMMMEd().format(article.timePublished);

    return Card(
      elevation: 0.2,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  timePub,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            if (article.leadData.image != null) ...[
              const SizedBox(height: 12),
              Image.network(article.leadData.image!.url)
            ],
            const SizedBox(height: 12),
            Text(
              article.titleHtml,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
