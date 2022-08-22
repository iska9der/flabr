import 'package:auto_route/auto_route.dart';

import '../../page/articles/article_page.dart';
import '../../page/articles/articles_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/news_page.dart';
import '../../page/services_page.dart';
import '../../page/settings_page.dart';
import '../../page/users/user_page.dart';
import '../../page/users/users_page.dart';
import 'routes/flows_route.dart';
import 'routes/services_route.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: DashboardPage,
      path: '/',
      children: [
        AutoRoute(
          path: FlowsRoute.routePath,
          name: FlowsRoute.routeName,
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              initial: true,
              path: ArticlesPage.routePath,
              name: ArticlesPage.routeName,
              page: ArticlesPage,
            ),
            AutoRoute(
              path: ArticlePage.routePath,
              name: ArticlePage.routeName,
              page: ArticlePage,
            ),
          ],
        ),
        AutoRoute(
          path: ServicesRoute.routePath,
          name: ServicesRoute.routeName,
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              initial: true,
              path: ServicesPage.routePath,
              name: ServicesPage.routeName,
              page: ServicesPage,
            ),
            AutoRoute(
              path: UsersPage.routePath,
              name: UsersPage.routeName,
              page: UsersPage,
            ),
            AutoRoute(
              path: UserPage.routePath,
              name: UserPage.routeName,
              page: UserPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'news',
          name: 'NewsRoute',
          page: NewsPage,
        ),
        AutoRoute(
          path: 'settings',
          name: 'SettingsRoute',
          page: SettingsPage,
        ),
      ],
    ),
  ],
)
// extend the generated private router
class $AppRouter {}
