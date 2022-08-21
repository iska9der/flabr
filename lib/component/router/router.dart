import 'package:auto_route/auto_route.dart';

import '../../page/article_page.dart';
import '../../page/articles_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/news_page.dart';
import '../../page/settings_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: DashboardPage,
      path: '/',
      children: [
        AutoRoute(
          path: 'articles',
          name: 'ArticlesRoute',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              name: 'AllArticlesRoute',
              page: ArticlesPage,
            ),
            AutoRoute(
              path: ':id',
              name: 'ArticleRoute',
              page: ArticlePage,
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
