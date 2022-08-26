import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../page/articles/article_detail_page.dart';
import '../../page/articles/article_list_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/news/news_list_page.dart';
import '../../page/services_page.dart';
import '../../page/settings_page.dart';
import '../../page/users/user_detail_page.dart';
import '../../page/users/user_list_page.dart';

import 'routes.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: DashboardPage,
      path: '/',
      children: [
        AutoRoute(
          initial: true,
          path: MyArticlesRoute.routePath,
          name: MyArticlesRoute.routeName,
          page: EmptyRouterPage,
          children: [
            RedirectRoute(path: '', redirectTo: 'list/all'),
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
          path: MyServicesRoute.routePath,
          name: MyServicesRoute.routeName,
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
        RedirectRoute(path: '*/post/:id', redirectTo: 'articles/:id'),
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
        RedirectRoute(
          path: '*/flows/:flow/',
          redirectTo: 'articles/list/:flow',
        ),
      ],
    ),
  ],
)

// extend the generated private router
class AppRouter extends _$AppRouter {
  /// Открыть статью в приложении, либо открыть внешнюю ссылку в браузере
  Future pushArticleOrExternal(Uri url) async {
    String id = parseId(url);

    if (isArticleUrl(url)) {
      return await push(ArticleDetailRoute(id: id));
    } else if (isUserUrl(url)) {
      return await push(UserDetailRoute(login: id));
    }

    return await launchUrlString(
      url.origin,
      mode: LaunchMode.externalApplication,
    );
  }

  String parseId(Uri url) {
    Iterable<String> parts =
        url.pathSegments.where((element) => element.isNotEmpty);

    return parts.last;
  }

  bool isArticleUrl(Uri url) {
    if (url.host.contains('habr.com')) {
      if (url.path.contains('post/') ||
          url.path.contains('blog/') ||
          url.path.contains('news/')) {
        return true;
      }
    }

    return false;
  }

  bool isUserUrl(Uri url) {
    if (url.host.contains('habr.com') && url.path.contains('user/')) {
      return true;
    }

    return false;
  }
}
