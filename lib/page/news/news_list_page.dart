import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/utils.dart';
import '../../common/widget/progress_indicator.dart';
import '../../feature/article/cubit/articles_cubit.dart';
import '../../feature/article/model/article_model.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/settings/cubit/settings_cubit.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticlesService>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
          child: const NewsListPageView(),
        ),
      ),
    );
  }
}

class NewsListPageView extends StatelessWidget {
  const NewsListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (p, c) =>
          p.langUI != c.langUI || p.langArticles != c.langArticles,
      listener: (context, state) {
        context.read<ArticlesCubit>().changeLanguage(
              langUI: state.langUI,
              langArticles: state.langArticles,
            );
      },
      child: BlocConsumer<ArticlesCubit, ArticlesState>(
        listenWhen: (p, c) =>
            c.status == ArticlesStatus.failure && c.error.isNotEmpty,
        listener: (c, state) {
          getIt.get<Utils>().showNotification(
                context: context,
                content: Text(state.error),
              );
        },
        builder: (context, state) {
          if (state.status == ArticlesStatus.initial) {
            context.read<ArticlesCubit>().fetchNews();

            return const CircleIndicator();
          }

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
      ),
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
