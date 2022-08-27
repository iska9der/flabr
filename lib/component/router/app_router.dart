import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../page/articles/article_detail_page.dart';
import '../../page/articles/article_list_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/news/news_list_page.dart';
import '../../page/services_page.dart';
import '../../page/settings_page.dart';
import '../../page/users/user_article_page.dart';
import '../../page/users/user_dashboard_page.dart';
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
        /// Таб "статьи"
        AutoRoute(
          initial: true,
          path: MyArticlesRoute.routePath,
          name: MyArticlesRoute.routeName,
          page: EmptyRouterPage,
          children: [
            RedirectRoute(path: '', redirectTo: 'flows/all'),
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

        /// Таб "сервисы"
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

            /// Вложенная навигация в деталях пользователя
            AutoRoute(
              path: UserDashboardPage.routePath,
              name: UserDashboardPage.routeName,
              page: UserDashboardPage,
              children: [
                AutoRoute(
                  path: UserDetailPage.routePath,
                  name: UserDetailPage.routeName,
                  page: UserDetailPage,
                ),
                AutoRoute(
                  path: UserArticlePage.routePath,
                  name: UserArticlePage.routeName,
                  page: UserArticlePage,
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          path: MyNewsRoute.routePath,
          name: MyNewsRoute.routeName,
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              initial: true,
              path: NewsListPage.routePath,
              name: NewsListPage.routeName,
              page: NewsListPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'settings',
          name: 'SettingsRoute',
          page: SettingsPage,
        ),

        /// Редиректы с хабропутей
        ///
        ///

        /// Флоу, статьи
        RedirectRoute(
          path: '*/flows/:flow/',
          redirectTo: 'articles/flows/:flow',
        ),
        RedirectRoute(path: '*/post/:id', redirectTo: 'articles/details/:id'),

        /// Пользователи/Авторы
        RedirectRoute(
          path: '*/users',
          redirectTo: 'services/users',
        ),
        RedirectRoute(
          path: '*/users/:login',
          redirectTo: 'services/users/:login',
        ),
        RedirectRoute(
          path: '*/users/:login/*',
          redirectTo: 'services/users/:login/detail',
        ),

        /// Новости
        /// todo: не работает
        RedirectRoute(
          path: '*/news/',
          redirectTo: 'news',
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
      return await navigate(ArticleDetailRoute(id: id));
    } else if (isUserUrl(url)) {
      return await navigate(
        UserDashboardRoute(login: id, children: const [UserDetailRoute()]),
      );
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
