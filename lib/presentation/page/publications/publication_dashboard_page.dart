import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/publication/publication_counters_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/app_router.dart';
import '../../../core/component/shortcuts/shortcuts_manager.dart';
import '../../../data/model/publication/publication.dart';
import '../../../data/model/user/user.dart';
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
              context.read<PublicationCountersBloc>().add(
                const PublicationCountersEvent.load(),
              );
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

          if (axis == AxisDirection.right || axis == AxisDirection.left) {
            return false;
          }

          double? newHeight = barHeight.value;
          if (direction == ScrollDirection.forward) {
            newHeight = themeHeight;
          } else if (direction == ScrollDirection.reverse) {
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
              alignment: Alignment.topCenter,
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
                    clipBehavior: Clip.hardEdge,
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
    final counters = context
        .select<PublicationCountersBloc, PublicationCounters>(
          (cubit) => cubit.state.counters,
        );

    final userUpdates = context.select<ProfileBloc, UserUpdates>(
      (cubit) => cubit.state.updates,
    );

    return ColoredBox(
      color: context.theme.colorScheme.surfaceContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                dividerColor: Colors.transparent,
                tabs: [
                  DashboardDrawerLinkWidget(
                    title: 'Моя лента',
                    count: userUpdates.feeds.newCount,
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
                    count: userUpdates.trackerUnreadCount,
                    isLabelVisible: userUpdates.trackerUnreadCount > 0,
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  tooltip: 'Трекер',
                  onPressed: () async {
                    final userBloc = context.read<ProfileBloc>();

                    await getIt<AppRouter>().push(
                      const TrackerDashboardRoute(),
                    );

                    userBloc.add(const ProfileEvent.fetchUpdates());
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
