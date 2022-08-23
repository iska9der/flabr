import 'package:auto_route/auto_route.dart';

import '../../page/articles/article_detail_page.dart';
import '../../page/articles/article_list_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/news/news_list_page.dart';
import '../../page/services_page.dart';
import '../../page/settings_page.dart';
import '../../page/users/user_detail_page.dart';
import '../../page/users/user_list_page.dart';
import 'routes.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: DashboardPage,
      path: '/',
      children: [
        AutoRoute(
          initial: true,
          path: ArticlesRoute.routePath,
          name: ArticlesRoute.routeName,
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: ArticleListPage.routePath,
              name: ArticleListPage.routeName,
              page: ArticleListPage,
            ),
            AutoRoute(
              path: ArticleDetailPage.routePath,
              name: ArticleDetailPage.routeName,
              page: ArticleDetailPage,
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
              path: UserListPage.routePath,
              name: UserListPage.routeName,
              page: UserListPage,
            ),
            AutoRoute(
              path: UserDetailPage.routePath,
              name: UserDetailPage.routeName,
              page: UserDetailPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'news',
          name: 'NewsRoute',
          page: NewsListPage,
        ),
        AutoRoute(
          path: 'settings',
          name: 'SettingsRoute',
          page: SettingsPage,
        ),

        /// todo: кривые редиректы
        /// deeplinks на autoroute помойка, по идее.
        /// спустя убитый на эту шляпу день,
        /// скорее всего ты переедешь на go_router
        ///
        ///
        RedirectRoute(path: '*/post/:id', redirectTo: 'articles/:id'),
        RedirectRoute(
          path: '*/flows/:flow',
          redirectTo: 'articles?flow=:flow',
        ),
        RedirectRoute(
          path: '*/users',
          redirectTo: 'services/users',
        ),
        RedirectRoute(
          path: '*/users/:login',
          redirectTo: 'services/users/:login',
        ),
        RedirectRoute(
          path: '*/news',
          redirectTo: 'news',
        ),
      ],
    ),
  ],
)

// extend the generated private router
class $AppRouter {}
