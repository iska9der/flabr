import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../feature/article/page/article_detail_page.dart';
import '../../feature/article/page/article_list_page.dart';
import '../../feature/article/page/comment_list_page.dart';
import '../../feature/article/page/news_detail_page.dart';
import '../../feature/article/page/news_list_page.dart';
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
  Future launchUrl(String url) async {
    return await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  /// Открыть ссылку в приложении, либо в браузере
  Future navigateOrLaunchUrl(Uri uri) async {
    String id = parseId(uri);

    if (isArticleUrl(uri)) {
      return await pushWidget(ArticleDetailPage(id: id));
    }

    if (isUserUrl(uri)) {
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

    return await launchUrl(uri.toString());
  }

  String parseId(Uri url) {
    Iterable<String> parts =
        url.pathSegments.where((element) => element.isNotEmpty);

    return parts.last;
  }

  bool _isHostCompatible(Uri uri) =>
      uri.host.contains('habr.com') || uri.host.contains('habrahabr.ru');

  bool isArticleUrl(Uri uri) {
    if (!_isHostCompatible(uri)) {
      return false;
    }

    if (uri.path.contains('post/') ||
        uri.path.contains('articles/') ||
        uri.path.contains('blog/') ||
        uri.path.contains('blogs/') ||
        uri.path.contains('news/')) {
      return true;
    }

    return false;
  }

  bool isUserUrl(Uri uri) {
    if (_isHostCompatible(uri) && uri.path.contains('users/')) {
      return true;
    }
    if (uri.host.isEmpty && uri.path.contains('/users/')) {
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

        /// /////////////////////
        /// Редиректы с хабропутей
        ///
        /// расположение редиректов важно

        /// Флоу в новостях
        RedirectRoute(
          path: '*/*/flows/:flow/news',
          redirectTo: 'news/flows/:flow',
        ),

        /// Новости и комментарии к ним
        RedirectRoute(
          path: '*/*/news/',
          redirectTo: 'news',
        ),
        RedirectRoute(
          path: '*/*/news/:id',
          redirectTo: 'news/details/:id',
        ),
        RedirectRoute(
          path: '*/*/news/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),
        RedirectRoute(
          path: '*/*/news/t/:id',
          redirectTo: 'news/details/:id',
        ),
        RedirectRoute(
          path: '*/*/news/t/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// /////////////////////
        /// Флоу в статьях
        RedirectRoute(
          path: '*/*/flows/:flow/',
          redirectTo: 'articles/flows/:flow',
        ),

        /// Статьи и комментарии к ним
        /// Старый путь
        RedirectRoute(
          path: '*/*/post/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/post/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Новые пути
        RedirectRoute(
          path: '*/*/posts/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/posts/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),
        RedirectRoute(
          path: '*/*/articles/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/articles/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Статьи из блогов и комментарии к ним
        /// todo: пока через вкладку "статьи"
        /// Старые пути
        RedirectRoute(
          path: '*/*/company/:companyName/blog/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/company/:companyName/blog/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Новые пути
        RedirectRoute(
          path: '*/*/companies/:companyName/articles/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/companies/:companyName/articles/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// Статьи с AMP ссылками
        RedirectRoute(
          path: '*/*/amp/publications/:id',
          redirectTo: 'articles/details/:id',
        ),
        RedirectRoute(
          path: '*/*/amp/publications/:id/comments',
          redirectTo: 'articles/comments/:id',
        ),

        /// /////////////////////
        /// Пользователи
        RedirectRoute(
          path: '*/*/users',
          redirectTo: 'services/users',
        ),

        /// Пользователь
        RedirectRoute(
          path: '*/*/users/:login',
          redirectTo: 'services/users/:login',
        ),

        /// Посты пользователя
        RedirectRoute(
          path: '*/*/users/:login/posts',
          redirectTo: 'services/users/:login/article',
        ),

        /// Остальные редиректы постов пользователя
        /// todo: временный редирект на экран всех постов пользователя,
        /// пока не реализованны вложенные разделы
        /// (публикации, посты)
        RedirectRoute(
          path: '*/*/users/:login/posts/*',
          redirectTo: 'services/users/:login/article',
        ),

        /// Закладки пользователя
        /// Старый путь
        RedirectRoute(
          path: '*/*/users/:login/favorites',
          redirectTo: 'services/users/:login/bookmarks',
        ),

        /// Новый путь
        RedirectRoute(
          path: '*/*/users/:login/bookmarks',
          redirectTo: 'services/users/:login/bookmarks',
        ),

        /// Остальные редиректы для закладок
        /// todo: временный редирект на закладки пользователя,
        /// пока не реализованны вложенные разделы
        /// (публикации, посты, комментарии)
        RedirectRoute(
          path: '*/*/users/:login/bookmarks/*',
          redirectTo: 'services/users/:login/bookmarks',
        ),

        /// Остальные редиректы для пользователей
        /// todo: временный редирект на детали пользователя,
        /// пока не реализованы вложенные разделы
        /// (комментарии, подписчики, подписки)
        RedirectRoute(
          path: '*/*/users/:login/*',
          redirectTo: 'services/users/:login/detail',
        ),

        /// /////////////////////
        /// Хабы
        RedirectRoute(
          path: '*/*/hubs',
          redirectTo: 'services/hubs',
        ),
        RedirectRoute(
          path: '*/*/hub/:alias',
          redirectTo: 'services/hubs/:alias/profile',
        ),

        /// Остальные редиректы для хабов
        /// todo: временный редирект в профиль хаба со статьями,
        /// пока не реализованы вложенные разделы
        /// (авторы, компании)
        RedirectRoute(
          path: '*/*/hub/:alias/*',
          redirectTo: 'services/hubs/:alias',
        ),
      ],
    ),
  ];
}
