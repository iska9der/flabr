import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../presentation/theme/theme.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../../../presentation/widget/enhancement/refresh_indicator.dart';
import '../../../presentation/widget/enhancement/responsive_visibility.dart';
import '../../auth/auth.dart';
import '../../most_reading/most_reading.dart';
import '../../scroll/scroll.dart';
import '../cubit/publication_list_cubit.dart';
import 'floating_filter_button.dart';
import 'publication_sliver_list.dart';

class PublicationListScaffold<
  ListCubit extends PublicationListCubit<ListState>,
  ListState extends PublicationListState
>
    extends StatelessWidget {
  const PublicationListScaffold({
    super.key,
    this.filter,
    this.showMostReading = true,
  });

  final Widget? filter;
  final bool showMostReading;

  @override
  Widget build(BuildContext context) {
    final pubCubit = context.read<ListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollController = scrollCubit.state.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (cubit) => cubit.state.misc.scrollVariant.physics(context),
    );

    final sidebarHeight =
        Device.getHeight(context) - AppDimensions.toolBarHeight;

    return MultiBlocListener(
      listeners: [
        /// Если пользователь вошел, надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listenWhen:
              (previous, current) =>
                  previous.status == AuthStatus.loading && current.isAuthorized,
          listener: (context, state) {
            pubCubit.refetch();
          },
        ),

        /// Если пользователь вышел, переполучаем статьи напрямую
        BlocListener<AuthCubit, AuthState>(
          listenWhen:
              (previous, current) =>
                  previous.status == AuthStatus.loading &&
                  current.isUnauthorized,
          listener: (context, state) {
            pubCubit.refetch();
          },
        ),

        /// Смена языков
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen:
              (previous, current) =>
                  previous.langUI != current.langUI ||
                  previous.langArticles != current.langArticles,
          listener: (_, __) => scrollCubit.animateToTop(),
        ),

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (_, current) => current.isBottomEdge,
          listener: (_, state) => pubCubit.fetch(),
        ),
      ],
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const FloatingScrollToTopButton(),
            if (filter != null)
              FloatingFilterButton<ListCubit, ListState>(filter: filter!),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              cacheExtent: 1000,
              controller: scrollController,
              physics: scrollPhysics,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: AppDimensions.tabBarHeight,
                  ),
                  sliver: FlabrSliverRefreshIndicator(
                    onRefresh: context.read<ListCubit>().refetch,
                  ),
                ),
                if (showMostReading)
                  const ResponsiveVisibilitySliver(
                    hiddenConditions: [
                      Condition.largerThan(
                        name: ScreenType.mobile,
                        value: false,
                      ),
                    ],
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: AppInsets.mostReadingMobile,
                        child: MostReadingWidget.button(),
                      ),
                    ),
                  ),
                SliverCrossAxisGroup(
                  slivers: [
                    PublicationSliverList<ListCubit, ListState>(),
                    ResponsiveVisibilitySliver(
                      visible: false,
                      visibleConditions: const [
                        Condition.largerThan(
                          name: ScreenType.mobile,
                          value: true,
                        ),
                      ],
                      replacementSliver: const SliverConstrainedCrossAxis(
                        maxExtent: 0,
                        sliver: SliverToBoxAdapter(),
                      ),
                      sliver: SliverConstrainedCrossAxis(
                        maxExtent:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 300,
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: ScreenType.desktop,
                                  value: Device.getWidth(context) / 3,
                                ),
                              ],
                            ).value,
                        sliver: SliverAppBar(
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.none,
                          toolbarHeight: sidebarHeight,
                          expandedHeight: sidebarHeight,
                          floating: true,
                          pinned: true,
                          flexibleSpace: const Padding(
                            padding: AppInsets.mostReadingDesktop,
                            child: _SideWidgetList(
                              widgets: [
                                _SideWidget(
                                  title: 'Читают сейчас',
                                  child: MostReadingWidget(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideWidgetList extends StatefulWidget {
  const _SideWidgetList({required this.widgets});

  final List<_SideWidget> widgets;

  @override
  State<_SideWidgetList> createState() => _SideWidgetListState();
}

class _SideWidgetListState extends State<_SideWidgetList> {
  int showIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.widgets.length > 1;
    final widgetHeight = Device.getHeight(context) / 2;

    return Wrap(
      runSpacing: 12,
      children:
          widget.widgets.mapIndexed((index, sideWidget) {
            final isActiveWidget = showIndex == index;

            return FlabrCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    enabled: isEnabled,
                    contentPadding: AppInsets.cardPadding.copyWith(
                      top: 0,
                      bottom: 0,
                    ),
                    title: Text(
                      sideWidget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing:
                        !isEnabled
                            ? null
                            : isActiveWidget
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                    onTap:
                        () => setState(() {
                          showIndex = index;
                        }),
                  ),
                  if (isActiveWidget) ...[
                    const Divider(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: widgetHeight),
                      child: sideWidget.child,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _SideWidget {
  const _SideWidget({required this.title, required this.child});

  final String title;
  final Widget child;
}
