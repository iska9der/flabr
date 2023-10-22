import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/article_settings_widget.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../common/widget/html_view_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_cubit.dart';
import '../repository/article_repository.dart';
import '../widget/article_footer_widget.dart';
import '../widget/article_header_widget.dart';
import '../widget/article_hubs_widget.dart';
import '../widget/article_labels_widget.dart';
import '../widget/stats/article_stats_widget.dart';

const double hPadding = 12.0;
const double vPadding = 10.0;

@RoutePage(name: ArticleDetailPage.routeName)
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    @PathParam() required this.id,
  });

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
  const ArticleDetailPageView({super.key});

  @override
  State<ArticleDetailPageView> createState() => _ArticleDetailPageViewState();
}

class _ArticleDetailPageViewState extends State<ArticleDetailPageView> {
  late final ScrollController controller;
  ValueNotifier<bool> isStatsVisible = ValueNotifier(true);
  ValueNotifier<double> progressValue = ValueNotifier(0.0);

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(_progressListener);

    super.initState();
  }

  @override
  dispose() {
    controller.removeListener(_progressListener);
    controller.dispose();
    super.dispose();
  }

  /// Вычисление прогресса скролла
  _progressListener() {
    final max = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    final normalized = (current - 0) / (max - 0);
    progressValue.value = normalized;
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
        floatingActionButton: ValueListenableBuilder(
          valueListenable: isStatsVisible,
          builder: (_, value, __) => _FloatingFooter(isVisible: value),
        ),
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
                    final axis = notification.metrics.axisDirection;

                    if (axis == AxisDirection.right ||
                        axis == AxisDirection.left) {
                      return true;
                    }

                    /// Если скроллим вверх, или скролл достиг какого-либо края,
                    /// то показываем статистику
                    if (direction == ScrollDirection.forward ||
                        notification.metrics.atEdge &&
                            notification.metrics.pixels != 0) {
                      isStatsVisible.value = true;
                    } else if (direction == ScrollDirection.reverse) {
                      isStatsVisible.value = false;
                    }

                    return true;
                  },
                  child: SelectionArea(
                    child: CustomScrollView(
                      controller: controller,
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          forceElevated: true,
                          pinned: true,
                          toolbarHeight: 40,
                          titleSpacing: 0,
                          title: Stack(
                            children: [
                              Row(
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
                                    icon:
                                        const Icon(Icons.brightness_6_rounded),
                                    iconSize: 20,
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
                              IgnorePointer(
                                child: SizedBox(
                                  height: 45,
                                  child: ValueListenableBuilder<double>(
                                    valueListenable: progressValue,
                                    builder: (context, value, child) {
                                      return LinearProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        color: Colors.blue.withOpacity(.2),
                                        value: value,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: vPadding,
                              left: hPadding,
                              right: hPadding,
                            ),
                            child: ArticleHeaderWidget(article),
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
                            child: ArticleStatsWidget(article),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: vPadding - 6,
                              left: hPadding,
                              right: hPadding,
                            ),
                            child: ArticleHubsWidget(hubs: article.hubs),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: hPadding,
                              right: hPadding,
                            ),
                            child: ArticleLabelsWidget(article),
                          ),
                        ),
                        HtmlView(textHtml: article.textHtml),
                      ],
                    ),
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

class _FloatingFooter extends StatelessWidget {
  const _FloatingFooter({this.isVisible = true});

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
              child: ArticleFooterWidget(
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
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

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
