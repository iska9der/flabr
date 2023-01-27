import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/html_view_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_cubit.dart';
import '../repository/article_repository.dart';
import '../widget/article_hub_widget.dart';
import '../widget/article_info_widget.dart';
import '../widget/article_settings_widget.dart';
import '../widget/article_statistics_widget.dart';

const double hPadding = 12.0;
const double vPadding = 6.0;

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    Key? key,
    @PathParam() required this.id,
  }) : super(key: key);

  final String id;

  static const String routePath = 'details/:id';
  static const String routeName = 'ArticleDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('article-$id-detail'),
      create: (c) => ArticleCubit(
        id,
        repository: getIt.get<ArticleRepository>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
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
  bool isStatsVisible = true;

  @override
  void initState() {
    controller = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (p, c) =>
          p.langUI != c.langUI || p.langArticles != c.langArticles,
      listener: (context, state) {
        /// Смена языков
        context.read<ArticleCubit>().changeLanguage(
              langUI: state.langUI,
              langArticles: state.langArticles,
            );
      },
      child: Scaffold(
        floatingActionButton: _FloatingStatistics(isVisible: isStatsVisible),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: BlocBuilder<ArticleCubit, ArticleState>(
            builder: (context, state) {
              if (state.status == ArticleStatus.initial) {
                context.read<ArticleCubit>().fetch();

                return const CircleIndicator();
              }
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

                    /// Если скроллим вверх, или скролл достиг нижнего края,
                    /// то показываем статистику
                    if (direction == ScrollDirection.forward ||
                        notification.metrics.atEdge &&
                            notification.metrics.pixels != 0) {
                      setState(() {
                        isStatsVisible = true;
                      });
                    } else if (direction == ScrollDirection.reverse) {
                      setState(() {
                        isStatsVisible = false;
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
                        forceElevated: true,
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
                                      .titleTextStyle,
                                ),
                              ),
                              const SizedBox(width: 14),
                              IconButton(
                                icon: const Icon(Icons.palette_rounded),
                                tooltip: 'Настроить показ',
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: kScreenHPadding,
                                        vertical: kScreenHPadding * 3,
                                      ),
                                      child: SizedBox(
                                        height: 240,
                                        child: ArticleSettingsWidget(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: vPadding,
                            left: hPadding,
                            right: hPadding,
                          ),
                          child: ArticleInfoWidget(article),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: vPadding,
                            left: hPadding,
                            right: hPadding,
                          ),
                          child: SelectableText(
                            article.titleHtml,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: vPadding,
                            left: hPadding,
                            right: hPadding,
                            bottom: vPadding,
                          ),
                          child: ArticleHubsWidget(hubs: article.hubs),
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
      ),
    );
  }
}

class _FloatingStatistics extends StatelessWidget {
  const _FloatingStatistics({Key? key, this.isVisible = true})
      : super(key: key);

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        if (state.article.isEmpty) return const SizedBox();

        final article = state.article;

        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized,
          offset: isVisible ? const Offset(0, 0) : const Offset(0, 10),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface.withOpacity(.95),
            child: SizedBox(
              height: 36,
              child: ArticleStatisticsWidget(
                article: article,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
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
    final theme = Theme.of(context);

    return Stack(
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
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
