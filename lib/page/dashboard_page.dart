import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/router/app_router.dart';
import '../config/constants.dart';
import '../feature/settings/cubit/settings_cubit.dart';

@RoutePage(name: DashboardPage.routeName)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = 'DashboardRoute';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double themeHeight = navBarHeight;
  ValueNotifier<double> barHeight = ValueNotifier(navBarHeight);
  bool visibleOnScroll = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.miscConfig.navigationOnScrollVisible !=
          current.miscConfig.navigationOnScrollVisible,
      listener: (context, state) {
        visibleOnScroll = state.miscConfig.navigationOnScrollVisible;
        if (visibleOnScroll) {
          barHeight.value = themeHeight;
        }
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (visibleOnScroll) {
            return true;
          }

          final direction = notification.direction;
          final axis = notification.metrics.axisDirection;

          if (axis == AxisDirection.right || axis == AxisDirection.left) {
            return true;
          }

          double? newHeight = barHeight.value;
          if (direction == ScrollDirection.forward) {
            newHeight = themeHeight;
          } else if (direction == ScrollDirection.reverse) {
            newHeight = 0;
          }
          barHeight.value = newHeight;

          return true;
        },
        child: AutoTabsScaffold(
          lazyLoad: false,
          routes: const [
            MyArticlesRoute(),
            MyNewsRoute(),
            MyServicesRoute(),
            SettingsRoute(),
          ],
          bottomNavigationBuilder: (context, tabsRouter) {
            return AnimatedBuilder(
              animation: barHeight,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: barHeight.value,
                  child: child,
                );
              },
              child: NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: (i) {
                  /// при нажатию на таб, в котором
                  /// мы уже находимся - выходим в корень
                  if (tabsRouter.activeIndex == i) {
                    var rootOfIndex = tabsRouter.stackRouterOfIndex(i);
                    rootOfIndex?.popUntilRoot();
                  } else {
                    tabsRouter.setActiveIndex(i);
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
              ),
            );
          },
        ),
      ),
    );
  }
}
