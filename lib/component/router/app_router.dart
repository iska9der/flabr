import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../feature/company/page/company_dashboard_page.dart';
import '../../feature/company/page/company_detail_page.dart';
import '../../feature/company/page/company_list_page.dart';
import '../../feature/hub/page/hub_dashboard_page.dart';
import '../../feature/hub/page/hub_detail_page.dart';
import '../../feature/hub/page/hub_list_page.dart';
import '../../feature/publication/page/article/article_comment_page.dart';
import '../../feature/publication/page/article/article_detail_page.dart';
import '../../feature/publication/page/article/article_list_page.dart';
import '../../feature/publication/page/news/news_comment_page.dart';
import '../../feature/publication/page/news/news_detail_page.dart';
import '../../feature/publication/page/news/news_list_page.dart';
import '../../feature/publication/page/post/post_comment_page.dart';
import '../../feature/publication/page/post/post_detail_page.dart';
import '../../feature/publication/page/post/post_list_page.dart';
import '../../feature/publication/page/publication_dashboard_page.dart';
import '../../feature/user/page/user_bookmark_list_page.dart';
import '../../feature/user/page/user_comment_list_page.dart';
import '../../feature/user/page/user_dashboard_page.dart';
import '../../feature/user/page/user_detail_page.dart';
import '../../feature/user/page/user_list_page.dart';
import '../../feature/user/page/user_publication_list_page.dart';
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
        ServicesRouter(
          children: [
            UserDashboardRoute(
              alias: id,
              children: const [UserDetailRoute()],
            )
          ],
        ),
      );
    }

    return await launchUrl(uri.toString());
  }

  String parseId(Uri url) {
    Iterable<String> parts = url.pathSegments.where(
      (element) => element.isNotEmpty,
    );

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
        /// Таб "Публикации"
        AutoRoute(
          initial: true,
          path: PublicationDashboardPage.routePath,
          page: PublicationsDashboardRoute.page,
          children: [
            /// Таб "Статьи"
            AutoRoute(
              path: ArticlesRouterData.routePath,
              page: ArticlesRouter.page,
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
                  path: 'comments/:id',
                  page: ArticleCommentsRoute.page,
                ),
              ],
            ),

            /// Таб "Посты"
            AutoRoute(
              path: PostsRouterData.routePath,
              page: PostsRouter.page,
              children: [
                RedirectRoute(path: '', redirectTo: 'flows/all'),
                AutoRoute(
                  path: PostListPage.routePath,
                  page: PostListRoute.page,
                ),
                AutoRoute(
                  path: PostDetailPage.routePath,
                  page: PostDetailRoute.page,
                ),
                AutoRoute(
                  path: 'comments/:id',
                  page: PostCommentsRoute.page,
                ),
              ],
            ),

            /// Таб "Новости"
            AutoRoute(
              path: NewsRouterData.routePath,
              page: NewsRouter.page,
              children: [
                RedirectRoute(path: '', redirectTo: 'flows/all'),
                AutoRoute(
                  path: NewsListPage.routePath,
                  page: NewsListRoute.page,
                ),
                AutoRoute(
                  path: NewsDetailPage.routePath,
                  page: NewsDetailRoute.page,
                ),
                AutoRoute(
                  path: 'comments/:id',
                  page: NewsCommentsRoute.page,
                ),
              ],
            ),
          ],
        ),

        /// Таб "Сервисы"
        AutoRoute(
          path: ServicesRouterData.routePath,
          page: ServicesRouter.page,
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
                  path: UserPublicationListPage.routePath,
                  page: UserPublicationListRoute.page,
                ),
                AutoRoute(
                  path: UserCommentListPage.routePath,
                  page: UserCommentListRoute.page,
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
          page: SettingsRouter.page,
        ),

        /// /////////////////////
        /// Редиректы с хабропутей
        ///
        /// расположение редиректов важно
        ..._newsRedirects(),
        ..._articlesRedirects(),
        ..._postsRedirects(),
        ..._usersRedirects(),
        ..._hubsRedirects(),
      ],
    ),
  ];
}

List<RedirectRoute> _newsRedirects() {
  return [
    /// Флоу в новостях
    RedirectRoute(
      path: '*/*/flows/:flow/news',
      redirectTo: 'news/flows/:flow',
    ),

    /// Новости
    RedirectRoute(
      path: '*/*/news/',
      redirectTo: 'news',
    ),

    /// Полная версия и комментарии
    RedirectRoute(
      path: '*/*/news/:id',
      redirectTo: 'news/details/:id',
    ),
    RedirectRoute(
      path: '*/*/news/:id/comments',
      redirectTo: 'news/comments/:id',
    ),
    RedirectRoute(
      path: '*/*/news/t/:id',
      redirectTo: 'news/details/:id',
    ),
    RedirectRoute(
      path: '*/*/news/t/:id/comments',
      redirectTo: 'news/comments/:id',
    ),
  ];
}

List<RedirectRoute> _articlesRedirects() {
  List<String> externalPathList = [
    '*/*/articles/:id',
    '*/articles/:id',
    '*/*/post/:id',
    '*/post/:id',

    /// Статьи из блогов и комментарии к ним
    /// TODO: пока через вкладку "статьи"
    '*/*/company/:companyName/blog/:id',
    '*/*/companies/:companyName/articles/:id',

    /// Статьи с AMP ссылками
    '*/*/amp/publications/:id',
  ];

  List<RedirectRoute> internalRedirectList = [];
  for (final path in externalPathList) {
    final list = [
      RedirectRoute(
        path: path,
        redirectTo: 'articles/details/:id',
      ),
      RedirectRoute(
        path: '$path/comments',
        redirectTo: 'articles/comments/:id',
      ),
    ];

    internalRedirectList.addAll(list);
  }

  return [
    /// Флоу в статьях
    RedirectRoute(
      path: '*/*/flows/:flow/',
      redirectTo: 'articles/flows/:flow',
    ),

    /// Статьи
    RedirectRoute(
      path: '*/*/articles/',
      redirectTo: 'articles',
    ),

    /// Полная версия и комментарии
    ...internalRedirectList,
  ];
}

List<RedirectRoute> _postsRedirects() {
  List<String> externalPathList = [
    '*/*/posts/:id',
    '*/posts/:id',
  ];

  List<RedirectRoute> internalRedirectList = [];
  for (final path in externalPathList) {
    final list = [
      RedirectRoute(
        path: path,
        redirectTo: 'posts/details/:id',
      ),
      RedirectRoute(
        path: '$path/comments',
        redirectTo: 'posts/comments/:id',
      ),
    ];

    internalRedirectList.addAll(list);
  }

  return [
    /// Флоу в постах
    RedirectRoute(
      path: '*/*/flows/:flow/posts',
      redirectTo: 'posts/flows/:flow',
    ),

    /// Посты
    RedirectRoute(
      path: '*/*/posts/',
      redirectTo: 'posts',
    ),

    /// Полная версия и комментарии
    ...internalRedirectList,
  ];
}

List<RedirectRoute> _usersRedirects() {
  const userList = UserListPage.routePath;
  const basePath = 'services/$userList';
  const details = UserDetailPage.routePath;
  const publications = UserPublicationListPage.routePath;
  const comments = UserCommentListPage.routePath;
  const bookmarks = UserBookmarkListPage.routePath;

  return [
    RedirectRoute(
      path: '*/*/users',
      redirectTo: basePath,
    ),

    /// Пользователь
    RedirectRoute(
      path: '*/*/users/:login',
      redirectTo: '$basePath/:login',
    ),

    /// Публикации пользователя
    RedirectRoute(
      path: '*/*/users/:login/publications',
      redirectTo: '$basePath/:login/$publications',
    ),
    RedirectRoute(
      path: '*/*/users/:login/publications/:type',
      redirectTo: '$basePath/:login/$publications/:type',
    ),
    RedirectRoute(
      path: '*/*/users/:login/posts', // Старый роут публикаций
      redirectTo: '$basePath/:login/$publications',
    ),

    /// Комментарии пользователя
    RedirectRoute(
      path: '*/*/users/:login/comments',
      redirectTo: '$basePath/:login/$comments',
    ),
    RedirectRoute(
      path: '*/*/users/:login/comments/*',
      redirectTo: '$basePath/:login/$comments',
    ),

    /// Закладки пользователя
    RedirectRoute(
      path: '*/*/users/:login/bookmarks',
      redirectTo: '$basePath/:login/$bookmarks',
    ),
    RedirectRoute(
      path: '*/*/users/:login/bookmarks/:type',
      redirectTo: '$basePath/:login/$bookmarks/:type',
    ),
    RedirectRoute(
      path: '*/*/users/:login/favorites', // Старый роут закладок
      redirectTo: '$basePath/:login/$bookmarks',
    ),

    /// Остальные редиректы для пользователей
    /// TODO: временный редирект на детали пользователя,
    /// пока не реализованы вложенные разделы
    /// (подписчики, подписки)
    RedirectRoute(
      path: '*/*/users/:login/*',
      redirectTo: '$basePath/:login/$details',
    ),
  ];
}

/// Редиректы для хабов
List<RedirectRoute> _hubsRedirects() {
  const hubList = HubListPage.routePath;
  const basePath = 'services/$hubList';
  const profile = HubDetailPage.routePath;

  return [
    RedirectRoute(
      path: '*/*/hubs',
      redirectTo: basePath,
    ),
    RedirectRoute(
      path: '*/*/hub/:alias',
      redirectTo: '$basePath/:alias/$profile',
    ),
    RedirectRoute(
      path: '*/*/hubs/:alias',
      redirectTo: '$basePath/:alias/$profile',
    ),

    /// TODO: временный редирект в профиль хаба со статьями,
    /// пока не реализованы вложенные разделы
    /// (авторы, компании)
    RedirectRoute(
      path: '*/*/hub/:alias/*',
      redirectTo: '$basePath/:alias',
    ),
    RedirectRoute(
      path: '*/*/hubs/:alias/*',
      redirectTo: '$basePath/:alias/$profile',
    ),
  ];
}
