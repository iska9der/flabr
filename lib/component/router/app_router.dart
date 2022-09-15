import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../feature/article/page/article_detail_page.dart';
import '../../feature/article/page/article_list_page.dart';
import '../../feature/article/page/news_detail_page.dart';
import '../../feature/article/page/news_list_page.dart';
import '../../feature/comment/page/comment_list_page.dart';
import '../../feature/hub/page/hub_dashboard_page.dart';
import '../../feature/hub/page/hub_detail_page.dart';
import '../../feature/hub/page/hub_list_page.dart';
import '../../feature/user/page/user_article_list_page.dart';
import '../../feature/user/page/user_bookmark_list_page.dart';
import '../../feature/user/page/user_dashboard_page.dart';
import '../../feature/user/page/user_detail_page.dart';
import '../../feature/user/page/user_list_page.dart';
import '../../page/dashboard_page.dart';
import '../../page/services_page.dart';
import '../../page/settings_page.dart';
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
            AutoRoute(
              path: CommentListPage.routePath,
              name: CommentListPage.routeName,
              page: CommentListPage,
            ),
          ],
        ),

        /// Таб "новости"
        AutoRoute(
          path: MyNewsRoute.routePath,
          name: MyNewsRoute.routeName,
          page: EmptyRouterPage,
          children: [
            RedirectRoute(path: '', redirectTo: 'flows/all'),
            AutoRoute(
              initial: true,
              path: NewsListPage.routePath,
              name: NewsListPage.routeName,
              page: NewsListPage,
            ),
            AutoRoute(
              path: NewsDetailPage.routePath,
              name: NewsDetailPage.routeName,
              page: NewsDetailPage,
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

            /// Хабы
            AutoRoute(
              path: HubListPage.routePath,
              name: HubListPage.routeName,
              page: HubListPage,
            ),

            /// Вложенная навигация в деталях хаба
            AutoRoute(
              path: HubDashboardPage.routePath,
              name: HubDashboardPage.routeName,
              page: HubDashboardPage,
              children: [
                AutoRoute(
                  path: HubDetailPage.routePath,
                  name: HubDetailPage.routeName,
                  page: HubDetailPage,
                ),
              ],
            ),

            /// Пользователи/Авторы
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
                  path: UserArticleListPage.routePath,
                  name: UserArticleListPage.routeName,
                  page: UserArticleListPage,
                ),
                AutoRoute(
                  path: UserBookmarkListPage.routePath,
                  name: UserBookmarkListPage.routeName,
                  page: UserBookmarkListPage,
                ),
              ],
            ),
          ],
        ),

        /// Таб "Настройки"
        AutoRoute(
          path: 'settings',
          name: 'SettingsRoute',
          page: SettingsPage,
        ),

        ///
        ///
        ///
        ///
        ///
        /// Редиректы с хабропутей
        ///
        /// расположение редиректов важно
        ///
        ///
        ///
        /// Новости [флоу, детали]
        RedirectRoute(
          path: '*/flows/:flow/news',
          redirectTo: 'news/flows/:flow',
        ),
        RedirectRoute(
          path: '*/news/',
          redirectTo: 'news',
        ),
        RedirectRoute(
          path: '*/news/t/:id',
          redirectTo: 'news/details/:id',
        ),

        /// Статьи [флоу, детали]
        RedirectRoute(
          path: '*/flows/:flow/',
          redirectTo: 'articles/flows/:flow',
        ),
        RedirectRoute(
          path: '*/post/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/post/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Статьи из блогов
        /// todo: пока через вкладку "статьи"
        RedirectRoute(
          path: '*/company/*/blog/:id',
          redirectTo: 'articles/details/:id',
        ),

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
          path: '*/users/:login/posts',
          redirectTo: 'services/users/:login/article',
        ),
        RedirectRoute(
          path: '*/users/:login/favorites',
          redirectTo: 'services/users/:login/bookmarks',
        ),

        /// todo: временный редирект на детали пользователя,
        /// пока не реализованы остальные вложенные пути
        /// (комментарии, подписчики, подписки)
        RedirectRoute(
          path: '*/users/:login/*',
          redirectTo: 'services/users/:login/detail',
        ),

        /// Хабы
        RedirectRoute(
          path: '*/hubs',
          redirectTo: 'services/hubs',
        ),
        RedirectRoute(
          path: '*/hub/:alias',
          redirectTo: 'services/hubs/:alias/profile',
        ),

        /// todo: временный редирект в профиль хаба со статьями,
        /// пока не реализованы остальные вложенные пути
        /// (авторы, компании)
        RedirectRoute(
          path: '*/hub/:alias/*',
          redirectTo: 'services/hubs/:alias',
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
      return await pushWidget(ArticleDetailPage(id: id));
    } else if (isUserUrl(url)) {
      return await navigate(
        ServicesEmptyRoute(children: [
          UserDashboardRoute(
            login: id,
            children: const [UserDetailRoute()],
          )
        ]),
      );
    }

    return await launchUrlString(
      url.toString(),
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
    if (url.host.contains('habr.com') && url.path.contains('users/')) {
      return true;
    } else if (url.host.isEmpty && url.path.contains('/users/')) {
      return true;
    }

    return false;
  }
}
