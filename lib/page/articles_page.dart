import 'package:cached_network_image/cached_network_image.dart';
import 'package:flabr/common/widget/progress_indicator.dart';
import 'package:flabr/config/constants.dart';
import 'package:flabr/feature/article/model/article_type.dart';
import 'package:flabr/feature/article/model/sort/period_enum.dart';
import 'package:flabr/feature/article/model/sort/sort_option_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../components/di/dependencies.dart';
import '../feature/article/cubit/articles_cubit.dart';
import '../feature/article/model/article_model.dart';
import '../feature/article/model/sort/sort_enum.dart';
import '../feature/article/service/article_service.dart';
import '../feature/article/widget/sort_widget.dart';

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

class ArticlesView extends StatelessWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .6,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ...ArticleType.values
                .map((type) => ListTile(
                      title: Text(type.label),
                      onTap: () {
                        context.read<ArticlesCubit>().changeType(type);

                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ArticlesCubit, ArticlesState>(
              builder: (context, state) {
                return SliverAppBar(
                  title: Text(state.type.label),
                  floating: true,
                  automaticallyImplyLeading: true,
                  expandedHeight: state.type == ArticleType.all ? 130 : null,
                  flexibleSpace: state.type == ArticleType.all
                      ? FlexibleSpaceBar(
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SortWidget(
                                currentValue: state.sort,
                                onTap: (value) => context
                                    .read<ArticlesCubit>()
                                    .changeSort(value),
                              ),
                              SortOptionsWidget(
                                options: state.sort == SortEnum.date
                                    ? PeriodEnum.values
                                        .map((period) => SortOptionModel(
                                              label: period.label,
                                              value: period,
                                            ))
                                        .toList()
                                    : ["+0", "+10", "+25", "+50", "+100"]
                                        .map((score) => SortOptionModel(
                                              label: score,
                                              value: score,
                                            ))
                                        .toList(),
                                currentValue: state.sort == SortEnum.date
                                    ? state.period
                                    : state.score,
                                onTap: (value) => context
                                    .read<ArticlesCubit>()
                                    .changeVariant(state.sort, value),
                              ),
                            ],
                          ),
                        )
                      : null,
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
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconText(
                  icon: Icons.thumbs_up_down,
                  text: article.statistics.score.toString(),
                  color:
                      article.statistics.score >= 0 ? Colors.green : Colors.red,
                ),
                IconText(
                  icon: Icons.mode_comment,
                  text: article.statistics.commentsCount.toString(),
                ),
                IconText(
                  icon: Icons.bookmark_border,
                  text: article.statistics.favoritesCount.toString(),
                ),
                IconText(
                  icon: Icons.remove_red_eye,
                  text: article.statistics.readingCount.toString(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required this.text,
    this.color,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
