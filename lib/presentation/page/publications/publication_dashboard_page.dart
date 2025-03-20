import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/di/injector.dart';
import '../../../core/component/router/app_router.dart';
import '../../../feature/auth/auth.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/dashboard_drawer_link_widget.dart';
import '../settings/cubit/settings_cubit.dart';
import 'bloc/publication_counters_bloc.dart';

@RoutePage(name: PublicationDashboardPage.routeName)
class PublicationDashboardPage extends StatefulWidget {
  const PublicationDashboardPage({super.key});

  static const String routePath = '';
  static const String routeName = 'PublicationDashboardRoute';

  @override
  State<PublicationDashboardPage> createState() =>
      _PublicationDashboardPageState();
}

class _PublicationDashboardPageState extends State<PublicationDashboardPage> {
  late final PublicationCountersBloc countersBloc;
  late final StreamSubscription authSub;

  final double themeHeight = AppDimensions.dashTabHeight;
  ValueNotifier<double> barHeight = ValueNotifier(AppDimensions.dashTabHeight);
  late bool visibleOnScroll;

  @override
  void initState() {
    countersBloc = PublicationCountersBloc(repository: getIt());
    authSub = context.read<AuthCubit>().stream.listen((state) {
      if (state.isAuthorized || state.isUnauthorized) {
        countersBloc.add(const PublicationCountersEvent.load());
      }
    });
    visibleOnScroll =
        context.read<SettingsCubit>().state.misc.navigationOnScrollVisible;

    super.initState();
  }

  @override
  void dispose() {
    authSub.cancel();
    countersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Слушаем изменение настройки видимости панели навигации
    return BlocListener<SettingsCubit, SettingsState>(
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
                        child: ColoredBox(
                          color: context.theme.colorScheme.surfaceContainerLow,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: BlocBuilder<PublicationCountersBloc,
                                    PublicationCountersState>(
                                  bloc: countersBloc,
                                  builder: (context, state) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: TabBar(
                                        controller: controller,
                                        isScrollable: true,
                                        padding: EdgeInsets.zero,
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        dividerColor: Colors.transparent,
                                        tabs: [
                                          BlocBuilder<AuthCubit, AuthState>(
                                            buildWhen: (previous, current) =>
                                                previous.updates !=
                                                current.updates,
                                            builder: (context, state) {
                                              return DashboardDrawerLinkWidget(
                                                title: 'Моя лента',
                                                count: state
                                                    .updates.feeds.newCount,
                                              );
                                            },
                                          ),
                                          DashboardDrawerLinkWidget(
                                            title: 'Статьи',
                                            count: state.counters.articles,
                                          ),
                                          DashboardDrawerLinkWidget(
                                            title: 'Посты',
                                            count: state.counters.posts,
                                          ),
                                          DashboardDrawerLinkWidget(
                                            title: 'Новости',
                                            count: state.counters.news,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.search_rounded),
                                    tooltip: 'Поиск',
                                    onPressed: () => getIt<AppRouter>().push(
                                      const SearchAnywhereRoute(),
                                    ),
                                  ),
                                  BlocBuilder<AuthCubit, AuthState>(
                                    buildWhen: (previous, current) =>
                                        previous.updates != current.updates ||
                                        previous.status != current.status,
                                    builder: (context, state) {
                                      if (state.isUnauthorized) {
                                        return const SizedBox();
                                      }

                                      return Badge.count(
                                        count: state.updates.trackerUnreadCount,
                                        isLabelVisible:
                                            state.updates.trackerUnreadCount >
                                                0,
                                        offset: const Offset(-8, 5),
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.notifications_outlined),
                                          tooltip: 'Трекер',
                                          onPressed: () async {
                                            final authCubit =
                                                context.read<AuthCubit>();

                                            await getIt<AppRouter>().push(
                                              const TrackerDashboardRoute(),
                                            );

                                            authCubit.fetchUpdates();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const MyProfileIconButton(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                Expanded(child: child),
              ],
            );
          },
        ),
      ),
    );
  }
}
