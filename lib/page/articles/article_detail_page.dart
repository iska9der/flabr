import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/widget/html_view_widget.dart';
import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/cubit/article_cubit.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/article/widget/article_card_widget.dart';

const double hPadding = 12.0;

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

class ArticleDetailPageView extends StatefulWidget {
  const ArticleDetailPageView({Key? key}) : super(key: key);

  @override
  State<ArticleDetailPageView> createState() => _ArticleDetailPageViewState();
}

class _ArticleDetailPageViewState extends State<ArticleDetailPageView> {
  late final ScrollController controller;
  bool isFabVisible = true;

  @override
  void initState() {
    controller = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _FloatingActionButtons(isVisible: isFabVisible),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
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

            return Scrollbar(
              controller: controller,
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final direction = notification.direction;

                  if (direction == ScrollDirection.forward) {
                    setState(() {
                      isFabVisible = true;
                    });
                  } else if (direction == ScrollDirection.reverse) {
                    setState(() {
                      isFabVisible = false;
                    });
                  }

                  return true;
                },
                child: CustomScrollView(
                  controller: controller,
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
                            const SizedBox(
                              width: 60,
                              child: AutoLeadingButton(),
                            ),
                            Expanded(
                              child: Text(
                                article.titleHtml,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle!,
                              ),
                            ),
                            const SizedBox(width: 14),
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
                        child: ArticleInfoWidget(article),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FloatingActionButtons extends StatelessWidget {
  const _FloatingActionButtons({Key? key, this.isVisible = true})
      : super(key: key);

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        var stats = state.article.statistics;

        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized,
          offset: isVisible ? const Offset(0, 0) : const Offset(0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ArticleFloatingButton(
                text: stats.score.toString(),
                icon: Icon(
                  Icons.insert_chart_rounded,
                  color: stats.score >= 0 ? Colors.green : Colors.red,
                ),
              ),
              ArticleFloatingButton(
                text: stats.commentsCount.toString(),
                icon: const Icon(Icons.chat_bubble_rounded),
              ),
              ArticleFloatingButton(
                text: stats.favoritesCount.toString(),
                icon: const Icon(Icons.bookmark_rounded),
              ),
              ArticleFloatingButton(
                text: stats.readingCount.toString(),
                icon: const Icon(Icons.remove_red_eye_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ArticleFloatingButton extends StatelessWidget {
  const ArticleFloatingButton({
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            FloatingActionButton.small(
              heroTag: UniqueKey(),
              onPressed: onPressed,
              child: icon,
            ),
            Positioned(
              bottom: 4,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button?.copyWith(
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(.8),
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
