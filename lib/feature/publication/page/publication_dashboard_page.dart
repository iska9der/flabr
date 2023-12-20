import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/widget/dashboard_drawer_link_widget.dart';
import '../../../component/router/app_router.dart';
import '../../../component/theme/constants.dart';

@RoutePage(name: PublicationDashboardPage.routeName)
class PublicationDashboardPage extends StatefulWidget {
  const PublicationDashboardPage({super.key});

  static const String routePath = '';
  static const String routeName = 'PublicationsDashboardRoute';

  @override
  State<PublicationDashboardPage> createState() =>
      _PublicationDashboardPageState();
}

class _PublicationDashboardPageState extends State<PublicationDashboardPage> {
  final _listRouteNames = const [
    ArticleListRoute.name,
    NewsListRoute.name,
    PostListRoute.name,
  ];

  /// Прячем табы когда мы не находимся в корне раздела "Публикации".
  /// Если не прятать, то когда мы переходим на какой-нибудь экран с помощью роутера
  /// это выглядит ущербно и занимает лишнее место сверху экрана
  final ValueNotifier<bool> isTabsVisible = ValueNotifier(false);
  ScrollPhysics? tabBarPhysics;

  @override
  void initState() {
    isTabsVisible.addListener(() {
      /// Если мы прячем табы, значит мы находимся не в корне раздела публикации,
      /// и нужно отключать горизонтальные жесты для переключения между табами,
      /// так как на запушенных экранах могут быть другие горизонтальные
      /// обработчики жестов, и табовый обработчик будет перехватывать их и
      /// переключать между табами вместо желаемого действия.
      /// Например:
      /// > открываем статью
      /// > открываем изображение
      /// > увеличиваем
      /// > пытаемся сместить центр к влево или вправо, чтобы увидеть
      /// необходимую часть изображения, то вместо смещения центра
      /// происходит переключение с таба "Статьи" на "Посты".
      ///
      /// Меняем стейт с помощью таймера, так как нельзя вызывать setState
      /// во время билда
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          tabBarPhysics =
              isTabsVisible.value ? null : const NeverScrollableScrollPhysics();
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    isTabsVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      physics: tabBarPhysics,
      routes: const [
        ArticlesRouter(),
        PostsRouter(),
        NewsRouter(),
      ],
      builder: (context, child, controller) {
        final currentName = AutoRouter.of(context).topMatch.name;

        final isHidden = _listRouteNames.any((name) => name == currentName);
        isTabsVisible.value = isHidden;

        return Column(
          children: [
            AnimatedBuilder(
              animation: isTabsVisible,
              builder: (context, child) {
                return AnimatedContainer(
                  height: isTabsVisible.value ? fDashboardTabHeight : 0,
                  duration: const Duration(milliseconds: 200),
                  child: child,
                );
              },
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(
                        title: 'Статьи',
                        route: 'articles',
                      ),
                      DashboardDrawerLinkWidget(
                        title: 'Посты',
                        route: 'posts',
                      ),
                      DashboardDrawerLinkWidget(
                        title: 'Новости',
                        route: 'news',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
