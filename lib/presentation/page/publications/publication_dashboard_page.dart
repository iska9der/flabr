import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/publication/publication_counters_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/router.dart';
import '../../../core/component/shortcuts/shortcuts_manager.dart';
import '../../../di/di.dart';
import '../../../feature/most_reading/most_reading.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/dashboard_drawer_link_widget.dart';
import '../../widget/profile/profile.dart';

@RoutePage(name: PublicationDashboardPage.routeName)
class PublicationDashboardPage extends StatelessWidget {
  const PublicationDashboardPage({super.key});

  static const String routePath = '';
  static const String routeName = 'PublicationDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MostReadingCubit(repository: getIt())),
        BlocProvider(
          create: (_) => PublicationCountersBloc(repository: getIt()),
        ),
      ],
      child: const PublicationDashboardView(),
    );
  }
}

class PublicationDashboardView extends StatefulWidget {
  const PublicationDashboardView({super.key});

  @override
  State<PublicationDashboardView> createState() =>
      _PublicationDashboardViewState();
}

class _PublicationDashboardViewState extends State<PublicationDashboardView> {
  final double themeHeight = AppDimensions.tabBarHeight;
  ValueNotifier<double> barHeight = ValueNotifier(AppDimensions.tabBarHeight);
  late bool visibleOnScroll;

  @override
  void initState() {
    super.initState();

    visibleOnScroll = context
        .read<SettingsCubit>()
        .state
        .misc
        .navigationOnScrollVisible;

    getIt<ShortcutsManager>().handleShortcuts();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Слушаем изменение настройки видимости панели навигации
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.misc.navigationOnScrollVisible !=
              current.misc.navigationOnScrollVisible,
          listener: (context, state) {
            visibleOnScroll = state.misc.navigationOnScrollVisible;
            if (visibleOnScroll) {
              /// сброс высоты навигации
              barHeight.value = themeHeight;
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isAuthorized || state.isUnauthorized) {
              context.read<PublicationCountersBloc>().add(const .load());
            }
          },
        ),
      ],
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (visibleOnScroll) {
            return false;
          }

          /// Слушаем уведомления о скролле, чтобы скрыть нижнюю навигацию,
          /// когда пользователь скроллит вниз
          final direction = notification.direction;
          final axis = notification.metrics.axisDirection;

          if (axis == .right || axis == .left) {
            return false;
          }

          double? newHeight = barHeight.value;
          if (direction == .forward) {
            newHeight = themeHeight;
          } else if (direction == .reverse) {
            newHeight = 0;
          }
          barHeight.value = newHeight;

          return false;
        },
        child: AutoTabsRouter.tabBar(
          routes: const [
            FeedFlowRoute(),
            ArticlesFlowRoute(),
            PostsFlowRoute(),
            NewsFlowRoute(),
          ],
          builder: (context, child, controller) {
            return Stack(
              alignment: .topCenter,
              children: [
                child,
                ValueListenableBuilder<double>(
                  valueListenable: barHeight,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: value,
                      child: child,
                    );
                  },

                  /// Без клипа иконки остаются на виду, когда шапка скрыта
                  child: ClipRRect(
                    clipBehavior: .hardEdge,
                    child: _DashboardAppBar(tabController: controller),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardAppBar extends StatelessWidget {
  // ignore: unused_element_parameter
  const _DashboardAppBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final counters = context.select(
      (PublicationCountersBloc bloc) => bloc.state.counters,
    );

    final updates = context.select((ProfileBloc bloc) => bloc.state.updates);

    return ColoredBox(
      color: context.theme.colorScheme.surfaceContainer,
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: Align(
              alignment: .centerLeft,
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: .center,
                labelPadding: const .symmetric(horizontal: 8),
                dividerColor: Colors.transparent,
                tabs: [
                  DashboardDrawerLinkWidget(
                    title: 'Моя лента',
                    count: updates.feeds.newCount,
                  ),
                  DashboardDrawerLinkWidget(
                    title: 'Статьи',
                    count: counters.articles,
                  ),
                  DashboardDrawerLinkWidget(
                    title: 'Посты',
                    count: counters.posts,
                  ),
                  DashboardDrawerLinkWidget(
                    title: 'Новости',
                    count: counters.news,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Поиск',
                onPressed: () =>
                    getIt<AppRouter>().push(const SearchAnywhereRoute()),
              ),
              if (context.read<AuthCubit>().state.isAuthorized)
                IconButton(
                  icon: Badge.count(
                    count: updates.trackerUnreadCount,
                    isLabelVisible: updates.trackerUnreadCount > 0,
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  tooltip: 'Трекер',
                  onPressed: () async {
                    final userBloc = context.read<ProfileBloc>();

                    await getIt<AppRouter>().push(
                      const TrackerDashboardRoute(),
                    );

                    userBloc.add(const .fetchUpdates());
                  },
                ),
              const MyProfileIconButton(),
            ],
          ),
        ],
      ),
    );
  }
}
