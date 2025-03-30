import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/router/app_router.dart';
import '../../../data/model/publication/publication.dart';
import '../../../data/model/user/user.dart';
import '../../../di/di.dart';
import '../../../feature/auth/auth.dart';
import '../../../feature/most_reading/most_reading.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/dashboard_drawer_link_widget.dart';
import '../settings/cubit/settings_cubit.dart';
import 'bloc/publication_counters_bloc.dart';

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
  final double themeHeight = AppDimensions.dashTabHeight;
  ValueNotifier<double> barHeight = ValueNotifier(AppDimensions.dashTabHeight);
  late bool visibleOnScroll;

  @override
  void initState() {
    visibleOnScroll =
        context.read<SettingsCubit>().state.misc.navigationOnScrollVisible;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Слушаем изменение настройки видимости панели навигации
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen:
              (previous, current) =>
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
            return Column(
              children: [
                AnimatedBuilder(
                  animation: barHeight,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: barHeight.value,
                      child: _DashboardAppBar(tabController: controller),
                    );
                  },
                ),
                Expanded(child: child),
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

    final userUpdates = context.select<AuthCubit, UserUpdates>(
      (cubit) => cubit.state.updates,
    );

    return ColoredBox(
      color: context.theme.colorScheme.surfaceContainerLow,
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
                    key: const Key('DashboardAppBar_MyFeed'),
                    title: 'Моя лента',
                    count: userUpdates.feeds.newCount,
                  ),
                  DashboardDrawerLinkWidget(
                    key: const Key('DashboardAppBar_Articles'),
                    title: 'Статьи',
                    count: counters.articles,
                  ),
                  DashboardDrawerLinkWidget(
                    key: const Key('DashboardAppBar_Posts'),
                    title: 'Посты',
                    count: counters.posts,
                  ),
                  DashboardDrawerLinkWidget(
                    key: const Key('DashboardAppBar_News'),
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
                onPressed:
                    () => getIt<AppRouter>().push(const SearchAnywhereRoute()),
              ),
              if (context.read<AuthCubit>().state.isAuthorized)
                IconButton(
                  key: const Key('DashboardAppBar_TrackerIcon'),
                  icon: Badge.count(
                    count: userUpdates.trackerUnreadCount,
                    isLabelVisible: userUpdates.trackerUnreadCount > 0,
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  tooltip: 'Трекер',
                  onPressed: () async {
                    await getIt<AppRouter>().push(
                      const TrackerDashboardRoute(),
                    );

                    if (context.mounted) {
                      context.read<AuthCubit>().fetchUpdates();
                    }
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
