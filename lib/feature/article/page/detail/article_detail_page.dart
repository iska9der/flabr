import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/widget/article_settings_widget.dart';
import '../../../../common/widget/enhancement/progress_indicator.dart';
import '../../../../common/widget/html_view_widget.dart';
import '../../../../component/di/dependencies.dart';
import '../../../../config/constants.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/article_cubit.dart';
import '../../model/helper/article_source.dart';
import '../../repository/article_repository.dart';
import '../../widget/article_footer_widget.dart';
import '../../widget/article_header_widget.dart';
import '../../widget/article_hubs_widget.dart';
import '../../widget/article_labels_widget.dart';
import '../../widget/article_more_widget.dart';
import '../../widget/detail/appbar_title_widget.dart';
import '../../widget/detail/title_widget.dart';
import '../../widget/stats/article_stats_widget.dart';

const double _hPadding = 12.0;
const double _vPadding = 10.0;

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
        source: ArticleSource.article,
        repository: getIt.get<ArticleRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
      ),
      child: const ItemDetailPageView(),
    );
  }
}

class ItemDetailPageView extends StatefulWidget {
  const ItemDetailPageView({super.key});

  @override
  State<ItemDetailPageView> createState() => _ItemDetailPageViewState();
}

class _ItemDetailPageViewState extends State<ItemDetailPageView> {
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
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: isStatsVisible,
        builder: (_, value, __) => _ArticleBottomBar(isVisible: value),
      ),
      body: SafeArea(
        bottom: false,
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
                    return false;
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

                  return false;
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
                                  child: ArticleDetailAppBarTitle(
                                    article: article,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.tune_rounded),
                                  iconSize: 18,
                                  tooltip: 'Настроить',
                                  onPressed: () => showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    builder: (context) {
                                      return const SizedBox(
                                        height: 240,
                                        child: ArticleSettingsWidget(),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  iconSize: 18,
                                  tooltip: 'Поделиться',
                                  onPressed: () => Share.shareUri(Uri.parse(
                                    '$baseUrl/articles/${article.id}',
                                  )),
                                ),
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
                            top: _vPadding,
                            left: _hPadding,
                            right: _hPadding,
                          ),
                          child: ArticleHeaderWidget(article),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ArticleDetailTitle(
                          article: article,
                          padding: const EdgeInsets.only(
                            top: _vPadding,
                            left: _hPadding,
                            right: _hPadding,
                            bottom: _vPadding,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: _vPadding,
                            left: _hPadding,
                            right: _hPadding,
                            bottom: _vPadding,
                          ),
                          child: ArticleStatsWidget(article),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: _vPadding - 6,
                            left: _hPadding,
                            right: _hPadding,
                          ),
                          child: ArticleHubsWidget(hubs: article.hubs),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: _hPadding,
                            right: _hPadding,
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
    );
  }
}

class _ArticleBottomBar extends StatelessWidget {
  const _ArticleBottomBar({this.isVisible = true});

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
          child: BottomAppBar(
            height: 36,
            padding: EdgeInsets.zero,
            elevation: 0,
            color: Theme.of(context).colorScheme.surface.withOpacity(.94),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 7,
                  child: ArticleFooterWidget(
                    article: article,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz_rounded),
                    tooltip: 'Дополнительно',
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: ArticleMoreOptionsWidget(article: article),
                      ),
                    ),
                  ),
                )
              ],
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
