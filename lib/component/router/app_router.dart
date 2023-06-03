import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../feature/article/page/article_detail_page.dart';
import '../../feature/article/page/article_list_page.dart';
import '../../feature/article/page/news_detail_page.dart';
import '../../feature/article/page/news_list_page.dart';
import '../../feature/comment/page/comment_list_page.dart';
import '../../feature/company/page/company_dashboard_page.dart';
import '../../feature/company/page/company_detail_page.dart';
import '../../feature/company/page/company_list_page.dart';
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

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  /// Открыть внешнюю ссылку
  Future launchExternalUrl(String url) async {
    return await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  /// Открыть статью в приложении, либо открыть внешнюю ссылку в браузере
  Future pushArticleOrExternal(Uri url) async {
    String id = parseId(url);

    if (isArticleUrl(url)) {
      return await pushWidget(ArticleDetailPage(id: id));
    } else if (isUserUrl(url)) {
      return await navigate(
        MyServicesRoute(
          children: [
            UserDashboardRoute(
              login: id,
              children: const [UserDetailRoute()],
            )
          ],
        ),
      );
    }

    return await launchExternalUrl(url.toString());
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

  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      page: DashboardRoute.page,
      path: '/',
      children: [
        /// Таб "статьи"
        AutoRoute(
          initial: true,
          path: MyArticlesRouteInfo.routePath,
          page: MyArticlesRoute.page,
          children: [
            RedirectRoute(path: '', redirectTo: 'flows/all'),
            AutoRoute(
              path: ArticleListPage.routePath,
              page: ArticleListRoute.page,
            ),
            AutoRoute(
              path: ArticleDetailPage.routePath,
              page: ArticleDetailRoute.page,
            ),
            AutoRoute(
              path: CommentListPage.routePath,
              page: ArticleCommentListRoute.page,
            ),
          ],
        ),

        /// Таб "новости"
        AutoRoute(
          path: MyNewsRouteInfo.routePath,
          page: MyNewsRoute.page,
          children: [
            RedirectRoute(path: '', redirectTo: 'flows/all'),
            AutoRoute(
              initial: true,
              path: NewsListPage.routePath,
              page: NewsListRoute.page,
            ),
            AutoRoute(
              path: NewsDetailPage.routePath,
              page: NewsDetailRoute.page,
            ),
          ],
        ),

        /// Таб "сервисы"
        AutoRoute(
          path: MyServicesRouteInfo.routePath,
          page: MyServicesRoute.page,
          children: [
            AutoRoute(
              initial: true,
              path: ServicesPage.routePath,
              page: ServicesRoute.page,
            ),

            /// Хабы
            AutoRoute(
              path: HubListPage.routePath,
              page: HubListRoute.page,
            ),
            AutoRoute(
              path: HubDashboardPage.routePath,
              page: HubDashboardRoute.page,
              children: [
                AutoRoute(
                  path: HubDetailPage.routePath,
                  page: HubDetailRoute.page,
                ),
              ],
            ),

            /// Пользователи/Авторы
            AutoRoute(
              path: UserListPage.routePath,
              page: UserListRoute.page,
            ),
            AutoRoute(
              path: UserDashboardPage.routePath,
              page: UserDashboardRoute.page,
              children: [
                AutoRoute(
                  path: UserDetailPage.routePath,
                  page: UserDetailRoute.page,
                ),
                AutoRoute(
                  path: UserArticleListPage.routePath,
                  page: UserArticleListRoute.page,
                ),
                AutoRoute(
                  path: UserBookmarkListPage.routePath,
                  page: UserBookmarkListRoute.page,
                ),
              ],
            ),

            /// Компании
            AutoRoute(
              path: CompanyListPage.routePath,
              page: CompanyListRoute.page,
            ),
            AutoRoute(
              path: CompanyDashboardPage.routePath,
              page: CompanyDashboardRoute.page,
              children: [
                AutoRoute(
                  path: CompanyDetailPage.routePath,
                  page: CompanyDetailRoute.page,
                ),
              ],
            ),
          ],
        ),

        /// Таб "Настройки"
        AutoRoute(
          path: 'settings',
          page: SettingsRoute.page,
        ),

        ///
        /// Редиректы с хабропутей
        ///
        /// расположение редиректов важно

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

        /// Флоу
        RedirectRoute(
          path: '*/flows/:flow/',
          redirectTo: 'articles/flows/:flow',
        ),

        /// Статьи
        RedirectRoute(
          path: '*/post/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/articles/:id',
          redirectTo: 'articles/details/:id',
        ),

        /// Комменты к статьям
        RedirectRoute(
          path: '*/post/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Статьи из блогов
        /// todo: пока через вкладку "статьи"
        RedirectRoute(
          path: '*/company/:companyName/blog/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/companies/:companyName/articles/:id',
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
  ];
}
