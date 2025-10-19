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
import '../../../../feature/publication_detail_ui/publication_detail_ui_cubit.dart';
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

// TODO(new-detail):
// 1. RepaintBoundary вокруг _PublicationContent для изоляции перерисовок
// 2. Hysteresis в скролл-логике (задержка перед скрытием баров)
// 3. Velocity-aware логика (быстрый скролл → скрываем быстрее)
// 4. Accessibility improvements (Semantics для screen readers)

class PublicationDetailView extends StatefulWidget {
  const PublicationDetailView({super.key});

  @override
  State<PublicationDetailView> createState() => _PublicationDetailViewState();
}

class _PublicationDetailViewState extends State<PublicationDetailView> {
  late final ScrollController _scrollController;
  late final PublicationDetailUICubit _uiCubit;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _uiCubit = PublicationDetailUICubit();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _uiCubit.close();

    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    if (max <= 0) return;

    final normalized = position.pixels / max;
    _uiCubit.updateScrollProgress(normalized);
  }

  void _fetchPublication() {
    context.read<PublicationDetailCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _uiCubit,
      child: Scaffold(
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
              builder: (context, state) => switch (state.status) {
                LoadingStatus.initial => _InitialView(
                  onRetry: _fetchPublication,
                ),
                LoadingStatus.loading => const _LoadingView(),
                LoadingStatus.failure => _ErrorView(
                  error: state.error,
                  onRetry: _fetchPublication,
                ),
                LoadingStatus.success => _SuccessView(
                  publication: state.publication,
                  scrollController: _scrollController,
                  uiCubit: _uiCubit,
                ),
              },
            ),
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

/// Состояние ошибки
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }
}

/// Основное содержимое (после успешной загрузки)
class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.publication,
    required this.scrollController,
    required this.uiCubit,
  });

  final Publication publication;
  final ScrollController scrollController;
  final PublicationDetailUICubit uiCubit;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) =>
          _handleScrollNotification(context, notification),
      child: Stack(
        children: [
          _PublicationContent(
            publication: publication,
            scrollController: scrollController,
          ),
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
      ),
    );
  }

  bool _handleScrollNotification(
    BuildContext context,
    UserScrollNotification notification,
  ) {
    final axis = notification.metrics.axisDirection;

    // Игнорируем горизонтальный скролл
    if (axis == AxisDirection.right || axis == AxisDirection.left) {
      return false;
    }

    final direction = notification.direction;
    final atEdge = notification.metrics.atEdge;
    final pixels = notification.metrics.pixels;

    // Показываем бары при скролле вверх или достижении краев
    if (direction == ScrollDirection.forward || (atEdge && pixels != 0)) {
      uiCubit.showBars();
    } else if (direction == ScrollDirection.reverse) {
      uiCubit.hideBars();
    }

    return false;
  }
}

/// Контейнер для AppBar с управлением видимостью
class _AppBarContainer extends StatelessWidget {
  const _AppBarContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
      builder: (context, state) {
        if (state.status != LoadingStatus.success) {
          return const SizedBox.shrink();
        }

        return BlocSelector<
          PublicationDetailUICubit,
          PublicationDetailUIState,
          bool
        >(
          selector: (state) => state.barsVisible,
          builder: (context, isVisible) {
            return _AppBar(
              publication: state.publication,
              isVisible: isVisible,
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationDetailCubit, PublicationDetailState>(
      builder: (context, state) {
        if (state.status != LoadingStatus.success) {
          return const SizedBox.shrink();
        }

        return BlocSelector<
          PublicationDetailUICubit,
          PublicationDetailUIState,
          bool
        >(
          selector: (state) => state.barsVisible,
          builder: (context, isVisible) {
            return _BottomBar(
              publication: state.publication,
              isVisible: isVisible,
            );
          },
        );
      },
    );
  }
}

/// Основной контент со всеми секциями
class _PublicationContent extends StatelessWidget {
  const _PublicationContent({
    required this.publication,
    required this.scrollController,
  });

  final Publication publication;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: CustomScrollView(
        controller: scrollController,
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
    );
  }

  Widget _buildTopPadding() {
    return const SliverPadding(
      padding: EdgeInsets.only(top: _appbarPadding),
    );
  }

  Widget _buildHeader() {
    return _SliverPaddedBox(
      padding: const EdgeInsets.symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationHeaderWidget(publication),
    );
  }

  Widget _buildTitle() {
    return _SliverPaddedBox(
      padding: const EdgeInsets.symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationDetailTitle(publication: publication),
    );
  }

  Widget _buildStats() {
    return _SliverPaddedBox(
      padding: const EdgeInsets.symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationStatsWidget(publication),
    );
  }

  Widget _buildHubs() {
    return _SliverPaddedBox(
      padding: const EdgeInsets.symmetric(
        vertical: _vPadding,
        horizontal: _hPadding,
      ),
      child: PublicationHubsWidget(hubs: publication.hubs),
    );
  }

  Widget _buildLabels() {
    return switch (publication) {
      PublicationCommon(:final postLabels, :final format) => _SliverPaddedBox(
        padding: const EdgeInsets.symmetric(
          vertical: _vPadding,
          horizontal: _hPadding,
        ),
        child: PublicationLabelList(
          postLabels: postLabels,
          format: format,
        ),
      ),
      _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
    };
  }

  Widget _buildLabelsData() {
    return switch (publication) {
      PublicationCommon(:final postLabels) when postLabels.isNotEmpty =>
        _SliverPaddedBox(
          padding: const EdgeInsets.symmetric(
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
  final EdgeInsets padding;

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

/// Оптимизированный AppBar с использованием BlocSelector
class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.publication,
    required this.isVisible,
  });

  final Publication publication;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      height: isVisible ? _appbarPadding : 10,
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          if (isVisible) _AppBarContent(publication: publication),
          const _ScrollProgressIndicator(),
        ],
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
      builder: (context) => const SizedBox(
        height: 240,
        child: PublicationSettingsWidget(),
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
        child:
            BlocSelector<
              PublicationDetailUICubit,
              PublicationDetailUIState,
              double
            >(
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

/// Оптимизированный BottomBar с использованием BlocSelector
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.publication,
    required this.isVisible,
  });

  final Publication publication;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
      offset: isVisible ? const Offset(0, 0) : const Offset(0, 10),
      child: ColoredBox(
        color: theme.colorScheme.surface.withValues(alpha: .94),
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
                onPressed: () => _showMoreSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 120,
        child: PublicationMoreButton(publication: publication),
      ),
    );
  }
}
