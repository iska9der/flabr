import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widget/progress_indicator.dart';
import '../feature/article/model/article_model.dart';
import '../components/di/dependencies.dart';
import '../feature/article/cubit/articles_cubit.dart';
import '../feature/article/service/article_service.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticleService>(),
          )..fetchNews(),
          child: const NewsView(),
        ),
      ),
    );
  }
}

class NewsView extends StatelessWidget {
  const NewsView({Key? key}) : super(key: key);

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

        var news = state.articles;

        return ListView.builder(
          itemCount: news.length,
          itemBuilder: (c, i) {
            return _Card(article: news[i]);
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
    return Card(
      elevation: 0.2,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(article.titleHtml),
      ),
    );
  }
}
