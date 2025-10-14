import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../../bloc/publication/publication_detail_cubit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/html_view_widget.dart';
import '../../../widget/publication_settings_widget.dart';
import 'card/card.dart';
import 'publication_more_button.dart';
import 'stats/stats.dart';

part 'publication_detail_appbar.dart';
part 'publication_detail_title.dart';

const double _hPadding = 12.0;
const double _vPadding = 6.0;
const double _appbarPadding = 40.0;

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
  void dispose() {
    controller.removeListener(_progressListener);
    controller.dispose();
    super.dispose();
  }

  void fetchPublication() {
    context.read<PublicationDetailCubit>().fetch();
  }

  /// Вычисление прогресса скролла
  void _progressListener() {
    final max = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    final normalized = (current - 0) / (max - 0);
    progressValue.value = normalized;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PublicationDetailCubit, PublicationDetailState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == LoadingStatus.success,
          listener: (context, state) {
            context.read<PublicationBookmarksBloc>().add(
              PublicationBookmarksEvent.updated(
                publications: [state.publication],
              ),
            );
          },
          child: BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
            builder: (context, state) {
              if (state.status == LoadingStatus.initial) {
                fetchPublication();

                return const CircleIndicator();
              }
              if (state.status == LoadingStatus.loading) {
                return const CircleIndicator();
              }
              if (state.status == LoadingStatus.failure) {
                return Center(
                  child: Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error),
                      FilledButton(
                        onPressed: () => fetchPublication(),
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                );
              }

              final publication = state.publication;

              return NotificationListener<UserScrollNotification>(
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
                child: Stack(
                  children: [
                    SelectionArea(
                      child: CustomScrollView(
                        controller: controller,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: _vPadding + _appbarPadding,
                                left: _hPadding,
                                right: _hPadding,
                              ),
                              child: PublicationHeaderWidget(publication),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: PublicationDetailTitle(
                              publication: publication,
                              padding: const EdgeInsets.symmetric(
                                vertical: _vPadding,
                                horizontal: _hPadding,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: _vPadding,
                                horizontal: _hPadding,
                              ),
                              child: PublicationStatsWidget(publication),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: _vPadding,
                                horizontal: _hPadding,
                              ),
                              child: PublicationHubsWidget(
                                hubs: publication.hubs,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: switch (publication) {
                              (PublicationCommon c) when c.format != null =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: _vPadding,
                                    horizontal: _hPadding,
                                  ),
                                  child: PublicationFormatWidget(c.format!),
                                ),
                              _ => const SizedBox(),
                            },
                          ),
                          HtmlView(textHtml: publication.textHtml),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder(
                        valueListenable: isStatsVisible,
                        builder: (_, isVisible, _) {
                          return _AppBar(
                            publication: publication,
                            isVisible: isVisible,
                            scrollProgress: progressValue,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder(
                        valueListenable: isStatsVisible,
                        builder: (_, value, _) => _BottomBar(
                          publication: publication,
                          isVisible: value,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.publication,
    required this.scrollProgress,
    this.isVisible = true,
  });

  final Publication publication;
  final bool isVisible;
  final ValueNotifier<double> scrollProgress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      height: isVisible ? _appbarPadding : 10,
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          if (isVisible)
            Row(
              children: [
                const SizedBox(width: 60, child: AutoLeadingButton()),
                Expanded(
                  child: PublicationDetailAppBarTitle(publication: publication),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  iconSize: 18,
                  tooltip: 'Настроить',
                  onPressed: () => showModalBottomSheet(
                    context: context,
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
                  onPressed: () {
                    final uri = Uri.parse(
                      '${Urls.baseUrl}/articles/${publication.id}',
                    );

                    Share.shareUri(uri);
                  },
                ),
              ],
            ),
          IgnorePointer(
            ignoring: isVisible,
            child: SizedBox(
              height: 45,
              child: ValueListenableBuilder<double>(
                valueListenable: scrollProgress,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    stopIndicatorColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    color: theme.colors.progressTrackColor,
                    value: value,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.publication, this.isVisible = true});

  final Publication publication;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
      offset: isVisible ? const Offset(0, 0) : const Offset(0, 10),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .94),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: AppDimensions.publicationBottomBarHeight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PublicationFooterWidget(
                  publication: publication,
                  isVoteBlocked: false,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                tooltip: 'Дополнительно',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: PublicationMoreButton(
                      publication: publication,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
