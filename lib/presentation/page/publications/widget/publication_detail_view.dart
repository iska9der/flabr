import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../../bloc/publication/publication_detail_cubit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/html_view/html_view_widget.dart';
import '../../../widget/navigation/navigation.dart';
import '../../../widget/publication_settings_widget.dart';
import 'card/card.dart';
import 'publication_more_button.dart';
import 'stats/stats.dart';

part 'publication_detail_appbar.dart';
part 'publication_detail_title.dart';

const double _hPadding = 12.0;
const double _vPadding = 6.0;
const double _appbarPadding = 40.0;

// TODO(new-detail):
// 1. RepaintBoundary вокруг _PublicationContent для изоляции перерисовок
// 2. Hysteresis в скролл-логике (задержка перед скрытием баров)
// 3. Velocity-aware логика (быстрый скролл → скрываем быстрее)
// 4. Accessibility improvements (Semantics для screen readers)

class PublicationDetailView extends StatelessWidget {
  const PublicationDetailView({super.key});

  void _fetch(BuildContext context) {
    context.read<PublicationDetailCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PublicationDetailCubit, PublicationDetailState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status == .success,
          listener: (context, state) {
            context.read<PublicationBookmarksBloc>().add(
              PublicationBookmarksEvent.updated(
                publications: [state.publication],
              ),
            );
          },
          child: BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
            builder: (context, state) => switch (state.status) {
              .initial => _InitialView(onRetry: () => _fetch(context)),
              .loading => const _LoadingView(),
              .failure => Center(
                child: AppError(
                  message: state.error,
                  onRetry: () => _fetch(context),
                ),
              ),
              .success => _SuccessView(publication: state.publication),
            },
          ),
        ),
      ),
    );
  }
}

/// Начальное состояние загрузки
class _InitialView extends StatelessWidget {
  const _InitialView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // Запускаем загрузку при первом рендере
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRetry();
    });

    return const SizedBox.shrink();
  }
}

/// Состояние загрузки
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => const CircleIndicator();
}

/// Основное содержимое (после успешной загрузки)
class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _PublicationContent(publication: publication),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _AppBarContainer(),
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomBarContainer(),
        ),
      ],
    );
  }
}

/// Контейнер для AppBar с управлением видимостью
class _AppBarContainer extends StatelessWidget {
  const _AppBarContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
      builder: (context, state) {
        if (state.status != .success) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, navState) {
            final isVisible = navState.isNavigationVisible;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              height: isVisible ? _appbarPadding : 10,
              color: Theme.of(context).colorScheme.surface,
              child: Stack(
                children: [
                  if (isVisible) _AppBarContent(publication: state.publication),
                  const _ScrollProgressIndicator(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Контейнер для BottomBar с управлением видимостью
class _BottomBarContainer extends StatelessWidget {
  const _BottomBarContainer();

  void _showMoreSheet(BuildContext context, Publication publication) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => SizedBox(
          width: .infinity,
          height: 120,
          child: PublicationMoreButton(publication: publication),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
      builder: (context, state) {
        if (state.status != .success) {
          return const SizedBox.shrink();
        }

        final theme = context.theme;
        final publication = state.publication;

        return BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return AnimatedSlide(
              duration: const .new(milliseconds: 300),
              curve: Curves.decelerate,
              offset: state.isNavigationVisible
                  ? const .new(0, 0)
                  : const .new(0, 10),
              child: ColoredBox(
                color: theme.colorScheme.surface.withValues(alpha: .94),
                child: ConstrainedBox(
                  constraints: const .new(
                    maxHeight: AppDimensions.publicationBottomBarHeight,
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      Expanded(
                        child: PublicationFooterWidget(
                          publication: publication,
                          isVoteBlocked: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz_rounded),
                        tooltip: 'Дополнительно',
                        onPressed: () => _showMoreSheet(context, publication),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Основной контент со всеми секциями
class _PublicationContent extends StatelessWidget {
  const _PublicationContent({required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.colors.card,
      child: SelectionArea(
        child: CustomScrollView(
          controller: context.read<ScrollCubit>().controller,
          slivers: [
            _buildTopPadding(),
            _buildHeader(),
            _buildTitle(),
            _buildStats(),
            _buildHubs(),
            _buildLabels(),
            _buildLabelsData(),
            _buildHtmlContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPadding() {
    return const SliverPadding(
      padding: .only(top: _appbarPadding),
    );
  }

  Widget _buildHeader() {
    return _SliverPaddedBox(
      padding: const .symmetric(vertical: _vPadding, horizontal: _hPadding),
      child: PublicationHeaderWidget(publication),
    );
  }

  Widget _buildTitle() {
    return _SliverPaddedBox(
      padding: const .symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationDetailTitle(publication: publication),
    );
  }

  Widget _buildStats() {
    return _SliverPaddedBox(
      padding: const .symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationStatsWidget(publication),
    );
  }

  Widget _buildHubs() {
    return _SliverPaddedBox(
      padding: const .symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationHubsWidget(hubs: publication.hubs),
    );
  }

  Widget _buildLabels() {
    final empty = const SliverToBoxAdapter(child: SizedBox.shrink());

    if (publication is! PublicationCommon) {
      return empty;
    }

    final common = publication as PublicationCommon;
    if (common.postLabels.isEmpty || common.format == null) {
      return empty;
    }

    return _SliverPaddedBox(
      padding: const .symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationLabelList(
        postLabels: common.postLabels,
        format: common.format,
      ),
    );
  }

  Widget _buildLabelsData() {
    return switch (publication) {
      PublicationCommon(:final postLabels) when postLabels.isNotEmpty =>
        _SliverPaddedBox(
          padding: const .symmetric(
            vertical: _vPadding,
            horizontal: _hPadding,
          ),
          child: PostLabelsDataList(postLabels: postLabels),
        ),
      _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
    };
  }

  Widget _buildHtmlContent() {
    return HtmlView(textHtml: publication.textHtml);
  }
}

/// Helper виджет для повторяющегося паттерна SliverToBoxAdapter + Padding
class _SliverPaddedBox extends StatelessWidget {
  const _SliverPaddedBox({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Содержимое AppBar (видно только когда isVisible = true)
class _AppBarContent extends StatelessWidget {
  const _AppBarContent({required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 60, child: AutoLeadingButton()),
        Expanded(
          child: PublicationDetailAppBarTitle(publication: publication),
        ),
        const _SettingsButton(),
        _ShareButton(publication: publication),
      ],
    );
  }
}

/// Кнопка настроек
class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune_rounded),
      iconSize: 18,
      tooltip: 'Настроить',
      onPressed: () => _showSettingsSheet(context),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: .fromLTRB(14, 0, 14, 18),
            child: PublicationSettingsWidget(),
          ),
        ],
      ),
    );
  }
}

/// Кнопка поделиться
class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      iconSize: 18,
      tooltip: 'Поделиться',
      onPressed: _sharePublication,
    );
  }

  void _sharePublication() {
    final uri = Uri.parse('${Urls.baseUrl}/articles/${publication.id}');
    SharePlus.instance.share(ShareParams(uri: uri));
  }
}

/// Индикатор прогресса скролла (виден только когда isVisible = false)
class _ScrollProgressIndicator extends StatelessWidget {
  const _ScrollProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return IgnorePointer(
      child: SizedBox(
        height: 45,
        child: BlocSelector<ScrollCubit, ScrollState, double>(
          selector: (state) => state.scrollProgress,
          builder: (context, progress) {
            return LinearProgressIndicator(
              stopIndicatorColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              color: theme.colors.progressTrackColor,
              value: progress,
            );
          },
        ),
      ),
    );
  }
}
