import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../common/utils/utils.dart';
import '../component/di/dependencies.dart';
import '../component/router/app_router.dart';
import '../component/theme/responsive.dart';
import '../config/constants.dart';
import '../feature/auth/cubit/auth_cubit.dart';
import '../feature/settings/cubit/settings_cubit.dart';

@RoutePage(name: DashboardPage.routeName)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = 'DashboardRoute';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double themeHeight = fNavBarHeight;
  ValueNotifier<double> barHeight = ValueNotifier(fNavBarHeight);
  late bool visibleOnScroll;

  @override
  void initState() {
    super.initState();

    visibleOnScroll = context
        .read<SettingsCubit>()
        .state
        .miscConfig
        .navigationOnScrollVisible;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Слушаем изменение настройки видимости нижней панели навигации
        BlocListener<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                previous.miscConfig.navigationOnScrollVisible !=
                current.miscConfig.navigationOnScrollVisible,
            listener: (context, state) {
              visibleOnScroll = state.miscConfig.navigationOnScrollVisible;
              if (visibleOnScroll) {
                barHeight.value = fNavBarHeight;
              }
            }),

        /// Выводим уведомление об ошибке, если возникла ошибка при получении
        /// данных о вошедшем юзере. Ошибка возникает, если при логине
        /// пришел некорректный connectSSID и [AuthCubit.fetchMe()]
        /// вернул null
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.isAuthorized && c.isAnomaly,
          listener: (context, state) {
            getIt.get<Utils>().showAlert(
                  context: context,
                  title: const Text('Ошибка авторизации'),
                  content: const Text(
                    'Возникли проблемы с полученым токеном\n\n'
                    'Попробуйте выйти и войти в аккаунт, или игнорируйте '
                    'это назойливое окно\n\n'
                    'Может само пройдет? 🤔',
                  ),
                  actionsBuilder: (context) => [
                    TextButton(
                      child: const Text('Выйти из аккаунта'),
                      onPressed: () {
                        context.read<AuthCubit>().logOut();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
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
        child: AutoTabsRouter(
          lazyLoad: false,
          routes: const [
            MyArticlesRoute(),
            MyNewsRoute(),
            MyServicesRoute(),
            SettingsRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;

            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: MaxWidthBox(
                    maxWidth: 1200,
                    child: Row(
                      children: [
                        ResponsiveVisibility(
                          visible: false,
                          visibleConditions: [
                            Condition.largerThan(
                              name: ScreenType.mobile,
                              value: true,
                            )
                          ],
                          child: _Drawer(router: tabsRouter),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: ResponsiveVisibility(
                hiddenConditions: [
                  Condition.largerThan(name: ScreenType.mobile, value: false)
                ],
                child: AnimatedBuilder(
                  animation: barHeight,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: barHeight.value,
                      child: child,
                    );
                  },
                  child: _BottomNavigation(router: tabsRouter),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({required this.router});

  final TabsRouter router;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(vertical: 10);

    return NavigationRail(
      elevation: 5,
      labelType: NavigationRailLabelType.all,
      selectedIndex: router.activeIndex,
      onDestinationSelected: (i) {
        /// при нажатию на таб, в котором
        /// мы уже находимся - выходим в корень
        if (router.activeIndex == i) {
          var rootOfIndex = router.stackRouterOfIndex(i);
          rootOfIndex?.popUntilRoot();
        } else {
          router.setActiveIndex(i);
        }
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.article_outlined),
          label: Text('Статьи'),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: Icon(Icons.newspaper_outlined),
          label: Text('Новости'),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: Icon(Icons.widgets_outlined),
          label: Text('Сервисы'),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          label: Text('Настройки'),
          padding: padding,
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.router});

  final TabsRouter router;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: router.activeIndex,
      onDestinationSelected: (i) {
        /// при нажатию на таб, в котором
        /// мы уже находимся - выходим в корень
        if (router.activeIndex == i) {
          var rootOfIndex = router.stackRouterOfIndex(i);
          rootOfIndex?.popUntilRoot();
        } else {
          router.setActiveIndex(i);
        }
      },
      destinations: const [
        NavigationDestination(
          label: 'Статьи',
          icon: Icon(Icons.article_outlined),
        ),
        NavigationDestination(
          label: 'Новости',
          icon: Icon(Icons.newspaper_outlined),
        ),
        NavigationDestination(
          label: 'Сервисы',
          icon: Icon(Icons.widgets_outlined),
        ),
        NavigationDestination(
          label: 'Настройки',
          icon: Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
