import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../core/component/router/app_router.dart';
import '../../feature/auth/auth.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final double themeHeight = context.theme.navigationBarTheme.height!;
  late final ValueNotifier<double> barHeight = ValueNotifier(themeHeight);
  late bool visibleOnScroll =
      context.read<SettingsCubit>().state.misc.navigationOnScrollVisible;

  @override
  void dispose() {
    barHeight.dispose();

    super.dispose();
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

        /// Выводим уведомление об ошибке, если возникла ошибка при получении
        /// данных о вошедшем юзере. Ошибка возникает, если при логине
        /// пришел некорректный connectSSID и [AuthCubit.fetchMe()]
        /// вернул null
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.isAuthorized && c.isAnomaly,
          listener: (context, state) {
            context.showAlert(
              title: const Text('Ошибка авторизации'),
              content: const Text(
                'Возникли проблемы с полученым токеном\n\n'
                'Попробуйте перезайти в аккаунт, или игнорируйте '
                'это назойливое окно\n\n'
                'Может само пройдет? 🤔',
              ),
              actionsBuilder:
                  (context) => [
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
            PublicationDashboardRoute(),
            ServicesFlowRoute(),
            SettingsRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;

            return Scaffold(
              body: SafeArea(
                child: Row(
                  children: [
                    ResponsiveVisibility(
                      visible: false,
                      visibleConditions: const [
                        Condition.largerThan(
                          name: ScreenType.mobile,
                          value: true,
                        ),
                      ],
                      child: _Drawer(router: tabsRouter),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
              bottomNavigationBar: ResponsiveVisibility(
                hiddenConditions: const [
                  Condition.largerThan(name: ScreenType.mobile, value: false),
                ],
                child: ValueListenableBuilder<double>(
                  valueListenable: barHeight,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: value,
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
          icon: Icon(Icons.article_rounded),
          label: Text('Публикации'),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: Icon(Icons.widgets_rounded),
          label: Text('Сервисы'),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_rounded),
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
          label: 'Публикации',
          icon: Icon(Icons.article_rounded),
        ),
        NavigationDestination(
          label: 'Сервисы',
          icon: Icon(Icons.widgets_rounded),
        ),
        NavigationDestination(
          label: 'Настройки',
          icon: Icon(Icons.settings_rounded),
        ),
      ],
    );
  }
}
