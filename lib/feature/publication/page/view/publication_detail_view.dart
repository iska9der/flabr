import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/part.dart';
import '../../../../presentation/widget/enhancement/progress_indicator.dart';
import '../../../../presentation/widget/html_view_widget.dart';
import '../../../../presentation/widget/publication_settings_widget.dart';
import '../../cubit/publication_detail_cubit.dart';
import '../../model/publication/publication.dart';
import '../../widget/card/components/footer_widget.dart';
import '../../widget/card/components/format_widget.dart';
import '../../widget/card/components/header_widget.dart';
import '../../widget/card/components/hubs_widget.dart';
import '../../widget/detail/appbar_title_widget.dart';
import '../../widget/detail/title_widget.dart';
import '../../widget/more/more_widget.dart';
import '../../widget/stats/stats_widget.dart';

const double _hPadding = 12.0;
const double _vPadding = 10.0;

class PublicationDetailView extends StatefulWidget {
  const PublicationDetailView({super.key});

  @override
  State<PublicationDetailView> createState() => _PublicationDetailViewState();
}

class _PublicationDetailViewState extends State<PublicationDetailView> {
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
        child: BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
          builder: (context, state) {
            if (state.status == PublicationStatus.initial) {
              context.read<PublicationDetailCubit>().fetch();

              return const CircleIndicator();
            }
            if (state.status == PublicationStatus.loading) {
              return const CircleIndicator();
            }
            if (state.status == PublicationStatus.failure) {
              return Center(child: Text(state.error));
            }

            final publication = state.publication;

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
                                  child: PublicationDetailAppBarTitle(
                                    publication: publication,
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
                                        child: PublicationSettingsWidget(),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  iconSize: 18,
                                  tooltip: 'Поделиться',
                                  onPressed: () => Share.shareUri(Uri.parse(
                                    '$baseUrl/articles/${publication.id}',
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
                          child: PublicationHeaderWidget(publication),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: PublicationDetailTitle(
                          publication: publication,
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
                          child: PublicationStatsWidget(publication),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: _vPadding - 6,
                            left: _hPadding,
                            right: _hPadding,
                          ),
                          child: PublicationHubsWidget(hubs: publication.hubs),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: switch (publication) {
                          (PublicationCommon a) when a.format != null =>
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _hPadding,
                              ),
                              child: PublicationFormatWidget(a.format!),
                            ),
                          _ => const SizedBox(),
                        },
                      ),
                      HtmlView(textHtml: publication.textHtml),
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
    return BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
      builder: (context, state) {
        if (state.publication.isEmpty) return const SizedBox();

        final publication = state.publication;

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
                    publication: publication,
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
                        child: PublicationMoreWidget(publication: publication),
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
