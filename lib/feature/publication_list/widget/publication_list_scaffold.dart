import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../presentation/theme/theme.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../../../presentation/widget/enhancement/refresh_indicator.dart';
import '../../../presentation/widget/enhancement/responsive_visibility.dart';
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
    this.bloc,
    this.filter,
    this.sidebarEnabled = true,
    this.showPublicationType = false,
  });

  final ListCubit? bloc;
  final Widget? filter;
  final bool sidebarEnabled;
  final bool showPublicationType;

  @override
  Widget build(BuildContext context) {
    final listCubit = bloc ?? context.read<ListCubit>();
    final scrollCubit = context.read<ScrollCubit>();

    return MultiBlocListener(
      listeners: [
        /// Если пользователь вошел или вышел - надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isAuthorized || state.isUnauthorized) {
              listCubit.reset();
            }
          },
        ),

        /// Смена языков
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (_, _) => scrollCubit.animateToTop(),
        ),

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (_, current) => current.isBottomEdge,
          listener: (_, state) => listCubit.fetch(),
        ),

        /// Синхронизация закладок при успешной загрузке публикаций
        BlocListener<ListCubit, ListState>(
          listenWhen: (_, current) =>
              current.status == PublicationListStatus.success,
          listener: (context, state) {
            context.read<PublicationBookmarksBloc>().add(
              PublicationBookmarksEvent.updated(
                publications: state.publications,
              ),
            );
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const FloatingScrollToTopButton(),
            if (filter != null)
              FloatingFilterButton(bloc: listCubit, filter: filter!),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: PublicationListScaffoldParams(
          filter: filter,
          sidebarEnabled: sidebarEnabled,
          showPublicationType: showPublicationType,
          child: _PublicationListView(bloc: listCubit),
        ),
      ),
    );
  }
}

class PublicationListScaffoldParams extends InheritedWidget {
  const PublicationListScaffoldParams({
    super.key,
    this.filter,
    this.sidebarEnabled = true,
    this.showPublicationType = false,
    required super.child,
  });

  final Widget? filter;
  final bool sidebarEnabled;
  final bool showPublicationType;

  @override
  bool updateShouldNotify(PublicationListScaffoldParams oldWidget) {
    return filter != oldWidget.filter ||
        sidebarEnabled != oldWidget.sidebarEnabled ||
        showPublicationType != oldWidget.showPublicationType;
  }

  static PublicationListScaffoldParams of(BuildContext context) {
    final PublicationListScaffoldParams? result = context
        .dependOnInheritedWidgetOfExactType<PublicationListScaffoldParams>();
    assert(result != null, 'No PublicationListParams found in context');
    return result!;
  }
}

class _PublicationListView<
  ListCubit extends PublicationListCubit<ListState>,
  ListState extends PublicationListState
>
    extends StatelessWidget {
  // ignore: unused_element_parameter
  const _PublicationListView({
    super.key,
    required this.bloc,
  });

  final ListCubit bloc;

  @override
  Widget build(BuildContext context) {
    final params = PublicationListScaffoldParams.of(context);
    final scrollController = context.read<ScrollCubit>().state.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (cubit) => cubit.state.misc.scrollVariant.physics(context),
    );

    return SafeArea(
      child: Scrollbar(
        controller: scrollController,
        child: CustomScrollView(
          cacheExtent: 1000,
          controller: scrollController,
          physics: scrollPhysics,
          slivers: [
            /// Обновление списка по свайпу
            SliverPadding(
              padding: const EdgeInsets.only(top: AppDimensions.tabBarHeight),
              sliver: FlabrSliverRefreshIndicator(onRefresh: bloc.reset),
            ),

            /// Кнопка "Читают сейчас"
            /// видна только на мобильных устройствах
            const ResponsiveVisibilitySliver(
              hiddenConditions: [
                Condition.largerThan(name: ScreenType.mobile, value: false),
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
                PublicationSliverList(
                  bloc: bloc,
                  showType: params.showPublicationType,
                ),

                /// Боковая панель с дополнительными виджетами, например "Читают сейчас"
                /// Видна на планшетах и десктопных устройствах,
                /// и если sidebarEnabled = true
                ResponsiveVisibilitySliver(
                  visible: false,
                  visibleConditions: params.sidebarEnabled
                      ? const [
                          Condition.largerThan(
                            name: ScreenType.mobile,
                            value: true,
                          ),
                        ]
                      : const [],
                  replacementSliver: const SliverConstrainedCrossAxis(
                    maxExtent: 0,
                    sliver: SliverToBoxAdapter(),
                  ),
                  sliver: Builder(
                    builder: (context) {
                      final sidebarHeight =
                          Device.getHeight(context) -
                          AppDimensions.toolBarHeight;

                      return SliverConstrainedCrossAxis(
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
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.none,
                          toolbarHeight: sidebarHeight,
                          expandedHeight: sidebarHeight,
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
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
                contentPadding: AppInsets.cardPadding.copyWith(
                  top: 0,
                  bottom: 0,
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
