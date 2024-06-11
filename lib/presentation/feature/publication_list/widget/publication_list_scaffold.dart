part of '../part.dart';

class PublicationListScaffold<ListCubit extends PublicationListCubit<ListState>,
    ListState extends PublicationListState> extends StatelessWidget {
  const PublicationListScaffold({
    super.key,
    this.appBar,
    this.showMostReading = true,
  });

  final Widget? appBar;
  final bool showMostReading;

  @override
  Widget build(BuildContext context) {
    final pubCubit = context.read<ListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollController = scrollCubit.state.controller;

    final sidebarHeight =
        Device.getHeight(context) - flowSortToolbarHeight - fToolBarHeight;

    return MultiBlocListener(
      listeners: [
        /// Если пользователь вошел, надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.status.isLoading && current.isAuthorized,
          listener: (context, state) {
            pubCubit.refetch();
          },
        ),

        /// Если пользователь вышел, переполучаем статьи напрямую
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.status.isLoading && current.isUnauthorized,
          listener: (context, state) {
            pubCubit.refetch();
          },
        ),

        /// Смена языков
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
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
        floatingActionButton: const FloatingScrollToTopButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              cacheExtent: 1000,
              controller: scrollController,
              slivers: [
                if (appBar != null) appBar!,
                if (showMostReading)
                  const ResponsiveVisibilitySliver(
                    hiddenConditions: [
                      Condition.largerThan(
                        name: ScreenType.mobile,
                        value: false,
                      )
                    ],
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: fCardMargin,
                          vertical: kCardBetweenPadding / 2,
                        ),
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
                        )
                      ],
                      replacementSliver: const SliverConstrainedCrossAxis(
                        maxExtent: 0,
                        sliver: SliverToBoxAdapter(),
                      ),
                      sliver: SliverConstrainedCrossAxis(
                        maxExtent: ResponsiveValue<double>(
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
                            padding: EdgeInsets.symmetric(
                              horizontal: kScreenHPadding,
                              vertical: kScreenHPadding,
                            ),
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
                )
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
      children: widget.widgets.mapIndexed((index, sideWidget) {
        final isActiveWidget = showIndex == index;

        return FlabrCard(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                enabled: isEnabled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: fCardPadding,
                ),
                title: Text(
                  sideWidget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: !isEnabled
                    ? null
                    : isActiveWidget
                        ? const Icon(Icons.keyboard_arrow_up_rounded)
                        : const Icon(Icons.keyboard_arrow_down_rounded),
                onTap: () => setState(() {
                  showIndex = index;
                }),
              ),
              if (isActiveWidget) ...[
                const Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widgetHeight),
                  child: sideWidget.child,
                )
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
