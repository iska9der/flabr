import 'package:cached_network_image/cached_network_image.dart';
import 'package:flabr/common/widget/progress_indicator.dart';
import 'package:flabr/config/constants.dart';
import 'package:flabr/feature/article/model/article_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../components/di/dependencies.dart';
import '../feature/article/cubit/articles_cubit.dart';
import '../feature/article/model/article_model.dart';
import '../feature/article/model/sort/sort_enum.dart';
import '../feature/article/service/article_service.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ArticlesCubit(
        getIt.get<ArticleService>(),
      )..fetchArticles(),
      child: const ArticlesView(),
    );
  }
}

class ArticlesView extends StatefulWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView>
    with TickerProviderStateMixin {
  late final TabController tabController = TabController(
    length: SortEnum.values.length,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .6,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              title: const Text('Все потоки'),
              onTap: () {
                context.read<ArticlesCubit>().changeType(ArticleType.all);

                Navigator.of(context).pop();
              },
            ),

            /// todo как появится авторизация, сделать вывод условным
            ListTile(
              title: const Text('Моя лента'),
              onTap: () {
                context.read<ArticlesCubit>().changeType(ArticleType.feed);

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              surfaceTintColor: Colors.transparent,
              floating: true,
            ),
            BlocBuilder<ArticlesCubit, ArticlesState>(
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: TabBar(
                    onTap: (value) =>
                        context.read<ArticlesCubit>().changeSort(value),
                    controller: tabController,
                    tabs: const [
                      Tab(text: 'По дням'),
                      Tab(text: 'По рейтингу'),
                    ],
                  ),
                );
              },
            ),
            BlocConsumer<ArticlesCubit, ArticlesState>(
              listenWhen: (p, c) =>
                  c.status == ArticlesStatus.error && c.error.isNotEmpty,
              listener: (c, s) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.error)),
                );
              },
              builder: (context, state) {
                if (state.status == ArticlesStatus.loading) {
                  return const SliverFillRemaining(
                    child: CircleIndicator(),
                  );
                }

                var articles = state.articles;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (c, i) {
                      return _Card(article: articles[i]);
                    },
                    childCount: articles.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final timePub =
        "${DateFormat.yMMMMd().format(article.timePublished)}, ${DateFormat.Hm().format(article.timePublished)}";

    return Card(
      elevation: 0.2,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              CachedNetworkImage(
                placeholder: (c, url) => const SizedBox(
                  height: postImageHeight,
                  child: CircleIndicator.small(),
                ),
                height: postImageHeight,
                imageUrl: article.leadData.image!.url,
              )
            ],
            const SizedBox(height: 12),
            Text(
              article.titleHtml,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
