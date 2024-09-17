import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../presentation/page/dashboard_page.dart';
import '../../../presentation/page/publications/articles/article_detail_page.dart';
import '../../../presentation/page/publications/articles/article_flow.dart';
import '../../../presentation/page/publications/articles/article_list_page.dart';
import '../../../presentation/page/publications/feed/feed_flow.dart';
import '../../../presentation/page/publications/feed/feed_list_page.dart';
import '../../../presentation/page/publications/news/news_flow.dart';
import '../../../presentation/page/publications/news/news_list_page.dart';
import '../../../presentation/page/publications/posts/post_list_page.dart';
import '../../../presentation/page/publications/posts/posts_flow.dart';
import '../../../presentation/page/publications/publication_comment_page.dart';
import '../../../presentation/page/publications/publication_dashboard_page.dart';
import '../../../presentation/page/publications/publication_detail_page.dart';
import '../../../presentation/page/publications/publication_flow.dart';
import '../../../presentation/page/publications/search/search_anywhere_page.dart';
import '../../../presentation/page/publications/tracker/tracker_dashboard_page.dart';
import '../../../presentation/page/publications/tracker/tracker_flow.dart';
import '../../../presentation/page/publications/tracker/tracker_publications_page.dart';
import '../../../presentation/page/publications/tracker/tracker_subscription_page.dart';
import '../../../presentation/page/publications/tracker/tracker_system_page.dart';
import '../../../presentation/page/services/company/page/company_dashboard_page.dart';
import '../../../presentation/page/services/company/page/company_detail_page.dart';
import '../../../presentation/page/services/company/page/company_list_page.dart';
import '../../../presentation/page/services/hub/page/hub_dashboard_page.dart';
import '../../../presentation/page/services/hub/page/hub_detail_page.dart';
import '../../../presentation/page/services/hub/page/hub_list_page.dart';
import '../../../presentation/page/services/services_flow.dart';
import '../../../presentation/page/services/services_page.dart';
import '../../../presentation/page/services/user/page/user_bookmark_list_page.dart';
import '../../../presentation/page/services/user/page/user_comment_list_page.dart';
import '../../../presentation/page/services/user/page/user_dashboard_page.dart';
import '../../../presentation/page/services/user/page/user_detail_page.dart';
import '../../../presentation/page/services/user/page/user_list_page.dart';
import '../../../presentation/page/services/user/page/user_publication_list_page.dart';
import '../../../presentation/page/settings/settings_page.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  /// Открыть внешнюю ссылку
  Future launchUrl(String url) => launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );

  /// Открыть ссылку в приложении, либо в браузере
  Future navigateOrLaunchUrl(Uri uri) async {
    final id = parseId(uri);

    if (id != null) {
      if (isArticleUrl(uri)) {
        return await pushWidget(ArticleDetailPage(id: id));
      }

      if (isUserUrl(uri)) {
        return await navigate(
          ServicesFlowRoute(
            children: [
              UserDashboardRoute(
                alias: id,
                children: [UserDetailRoute()],
              )
            ],
          ),
        );
      }
    }

    return await launchUrl(uri.toString());
  }

  String? parseId(Uri url) {
    Iterable<String> parts = url.pathSegments.where(
      (element) => element.isNotEmpty,
    );

    if (parts.isEmpty) {
      return null;
    }

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
      initial: true,
      children: [
        /////////////////////////
        /// Таб "Публикации"
        AutoRoute(
          initial: true,
          path: PublicationDashboardPage.routePath,
          page: PublicationDashboardRoute.page,
          children: [
            /// Таб "Моя лента"
            AutoRoute(
              initial: true,
              page: FeedFlowRoute.page,
              path: FeedFlowPage.routePath,
              children: [
                AutoRoute(
                  path: FeedListPage.routePath,
                  page: FeedListRoute.page,
                ),
              ],
            ),

            /// Таб "Статьи"
            AutoRoute(
              page: ArticlesFlowRoute.page,
              path: ArticlesFlowPage.routePath,
              children: [
                RedirectRoute(path: '', redirectTo: 'flows/all'),
                AutoRoute(
                  path: ArticleListPage.routePath,
                  page: ArticleListRoute.page,
                ),
              ],
            ),

            /// Таб "Посты"
            AutoRoute(
              page: PostsFlowRoute.page,
              path: PostsFlowPage.routePath,
              children: [
                RedirectRoute(path: '', redirectTo: 'flows/all'),
                AutoRoute(
                  path: PostListPage.routePath,
                  page: PostListRoute.page,
                ),
              ],
            ),

            /// Таб "Новости"
            AutoRoute(
              page: NewsFlowRoute.page,
              path: NewsFlowPage.routePath,
              children: [
                RedirectRoute(path: '', redirectTo: 'flows/all'),
                AutoRoute(
                  page: NewsListRoute.page,
                  path: NewsListPage.routePath,
                ),
              ],
            ),
          ],
        ),

        /////////////////////////
        /// Таб "Сервисы"
        AutoRoute(
          page: ServicesFlowRoute.page,
          path: ServicesFlowPage.routePath,
          children: [
            AutoRoute(
              initial: true,
              page: ServicesRoute.page,
              path: ServicesPage.routePath,
            ),

            /// Хабы
            AutoRoute(
              page: HubListRoute.page,
              path: HubListPage.routePath,
            ),
            _hubDashboard(),

            /// Пользователи/Авторы
            AutoRoute(
              page: UserListRoute.page,
              path: UserListPage.routePath,
            ),
            _userDashboard(),

            /// Компании
            AutoRoute(
              page: CompanyListRoute.page,
              path: CompanyListPage.routePath,
            ),
            _companyDashboard(),
          ],
        ),

        /// Таб "Настройки"
        AutoRoute(
          page: SettingsRoute.page,
          path: SettingsPage.routePath,
        ),
      ],
    ),

    /// Поиск
    AutoRoute(
      page: SearchAnywhereRoute.page,
      path: SearchAnywherePage.routePath,
    ),

    /// Трекер
    AutoRoute(
      page: TrackerFlowRoute.page,
      path: TrackerFlowPage.routePath,
      children: [
        AutoRoute(
          initial: true,
          page: TrackerDashboardRoute.page,
          path: TrackerDashboardPage.routePath,
          children: [
            AutoRoute(
              initial: true,
              page: TrackerPublicationsRoute.page,
              path: TrackerPublicationsPage.routePath,
            ),
            AutoRoute(
              page: TrackerSystemRoute.page,
              path: TrackerSystemPage.routePath,
            ),
            AutoRoute(
              page: TrackerSubscriptionRoute.page,
              path: TrackerSubscriptionPage.routePath,
            ),
          ],
        ),
      ],
    ),

    /// Просмотр публикации
    AutoRoute(
      page: PublicationFlowRoute.page,
      path: PublicationFlowPage.routePath,
      children: [
        AutoRoute(
          initial: true,
          page: PublicationDetailRoute.page,
          path: PublicationDetailPage.routePath,
        ),
        AutoRoute(
          page: PublicationCommentRoute.page,
          path: PublicationCommentPage.routePath,
        ),
      ],
    ),

    _userDashboard(isRoot: true),
    _companyDashboard(isRoot: true),
    _hubDashboard(isRoot: true),

    /// /////////////////////
    /// Редиректы с хабропутей
    ///
    /// расположение редиректов важно
    ..._newsRedirects(),
    ..._articlesRedirects(),
    ..._postsRedirects(),
    ..._usersRedirects(),
    ..._hubsRedirects(),
  ];
}

AutoRoute _userDashboard({bool isRoot = false}) => AutoRoute(
      page: UserDashboardRoute.page,
      path: "${isRoot == true ? '/' : ''}${UserDashboardPage.routePath}",
      children: [
        AutoRoute(
          initial: true,
          page: UserDetailRoute.page,
          path: UserDetailPage.routePath,
        ),
        AutoRoute(
          page: UserPublicationListRoute.page,
          path: UserPublicationListPage.routePath,
        ),
        AutoRoute(
          page: UserCommentListRoute.page,
          path: UserCommentListPage.routePath,
        ),
        AutoRoute(
          page: UserBookmarkListRoute.page,
          path: UserBookmarkListPage.routePath,
        ),
      ],
    );

AutoRoute _hubDashboard({bool isRoot = false}) => AutoRoute(
      page: HubDashboardRoute.page,
      path: "${isRoot == true ? '/' : ''}${HubDashboardPage.routePath}",
      children: [
        AutoRoute(
          initial: true,
          page: HubDetailRoute.page,
          path: HubDetailPage.routePath,
        ),
      ],
    );

AutoRoute _companyDashboard({bool isRoot = false}) => AutoRoute(
      page: CompanyDashboardRoute.page,
      path: "${isRoot == true ? '/' : ''}${CompanyDashboardPage.routePath}",
      children: [
        AutoRoute(
          initial: true,
          page: CompanyDetailRoute.page,
          path: CompanyDetailPage.routePath,
        ),
      ],
    );

List<RedirectRoute> _newsRedirects() {
  return [
    /// Флоу в новостях
    RedirectRoute(
      path: '/flows/:flow/news',
      redirectTo: '/news/flows/:flow',
    ),

    /// Новости
    RedirectRoute(
      path: '/news/',
      redirectTo: '/news',
    ),

    /// Полная версия и комментарии
    RedirectRoute(
      path: '/news/:id',
      redirectTo: '/publication/news/:id',
    ),
    RedirectRoute(
      path: '/news/:id/comments',
      redirectTo: '/publication/news/:id/comments',
    ),
    RedirectRoute(
      path: '/news/t/:id',
      redirectTo: '/publication/news/:id',
    ),
    RedirectRoute(
      path: '/news/t/:id/comments',
      redirectTo: '/publication/news/:id/comments',
    ),
  ];
}

List<RedirectRoute> _articlesRedirects() {
  List<String> externalPathList = [
    '/articles/:id',
    '/post/:id',

    /// Статьи из блогов и комментарии к ним
    /// TODO: пока через вкладку "статьи"
    '/company/:companyName/blog/:id',
    '/companies/:companyName/articles/:id',

    /// Статьи с AMP ссылками
    '/*/amp/publications/:id',
  ];

  List<RedirectRoute> internalRedirectList = [];
  for (final path in externalPathList) {
    final list = [
      RedirectRoute(
        path: path,
        redirectTo: '/publication/article/:id',
      ),
      RedirectRoute(
        path: '$path/comments',
        redirectTo: '/publication/article/:id/comments',
      ),
    ];

    internalRedirectList.addAll(list);
  }

  return [
    /// Флоу в статьях
    RedirectRoute(
      path: '/flows/:flow/',
      redirectTo: '/articles/flows/:flow',
    ),
    RedirectRoute(
      path: '/flows/:flow/articles',
      redirectTo: '/articles/flows/:flow',
    ),

    /// Статьи
    RedirectRoute(
      path: '/articles/',
      redirectTo: '/articles',
    ),

    /// Полная версия и комментарии
    ...internalRedirectList,
  ];
}

List<RedirectRoute> _postsRedirects() {
  List<String> externalPathList = [
    '/posts/:id',
  ];

  List<RedirectRoute> internalRedirectList = [];
  for (final path in externalPathList) {
    final list = [
      RedirectRoute(
        path: path,
        redirectTo: '/publication/post/:id',
      ),
      RedirectRoute(
        path: '$path/comments',
        redirectTo: '/publication/post/:id/comments',
      ),
    ];

    internalRedirectList.addAll(list);
  }

  return [
    /// Флоу в постах
    RedirectRoute(
      path: '/flows/:flow/posts',
      redirectTo: '/posts/flows/:flow',
    ),

    /// Посты
    RedirectRoute(
      path: '/posts/',
      redirectTo: '/posts',
    ),

    /// Полная версия и комментарии
    ...internalRedirectList,
  ];
}

List<RedirectRoute> _usersRedirects() {
  const userList = UserListPage.routePath;
  const basePath = '/services/$userList';
  const details = UserDetailPage.routePath;
  const publications = UserPublicationListPage.routePath;
  const comments = UserCommentListPage.routePath;
  const bookmarks = UserBookmarkListPage.routePath;

  return [
    RedirectRoute(
      path: '/users',
      redirectTo: basePath,
    ),

    /// Пользователь
    RedirectRoute(
      path: '/users/:login',
      redirectTo: '$basePath/:login',
    ),

    /// Публикации пользователя
    RedirectRoute(
      path: '/users/:login/publications',
      redirectTo: '$basePath/:login/$publications',
    ),
    RedirectRoute(
      path: '/users/:login/publications/:type',
      redirectTo: '$basePath/:login/$publications/:type',
    ),
    RedirectRoute(
      path: '/users/:login/posts', // Старый роут публикаций
      redirectTo: '$basePath/:login/$publications',
    ),

    /// Комментарии пользователя
    RedirectRoute(
      path: '/users/:login/comments',
      redirectTo: '$basePath/:login/$comments',
    ),
    RedirectRoute(
      path: '/users/:login/comments/*',
      redirectTo: '$basePath/:login/$comments',
    ),

    /// Закладки пользователя
    RedirectRoute(
      path: '/users/:login/bookmarks',
      redirectTo: '$basePath/:login/$bookmarks',
    ),
    RedirectRoute(
      path: '/users/:login/bookmarks/:type',
      redirectTo: '$basePath/:login/$bookmarks/:type',
    ),
    RedirectRoute(
      path: '/users/:login/favorites', // Старый роут закладок
      redirectTo: '$basePath/:login/$bookmarks',
    ),

    /// Остальные редиректы для пользователей
    /// TODO: временный редирект на детали пользователя,
    /// пока не реализованы вложенные разделы
    /// (подписчики, подписки)
    RedirectRoute(
      path: '/users/:login/*',
      redirectTo: '$basePath/:login/$details',
    ),
  ];
}

/// Редиректы для хабов
List<RedirectRoute> _hubsRedirects() {
  const hubList = HubListPage.routePath;
  const basePath = '/services/$hubList';
  const profile = HubDetailPage.routePath;

  return [
    RedirectRoute(
      path: '/hubs',
      redirectTo: basePath,
    ),
    RedirectRoute(
      path: '/hub/:alias',
      redirectTo: '$basePath/:alias/$profile',
    ),
    RedirectRoute(
      path: '/hubs/:alias',
      redirectTo: '$basePath/:alias/$profile',
    ),

    /// TODO: временный редирект в профиль хаба со статьями,
    /// пока не реализованы вложенные разделы
    /// (авторы, компании)
    RedirectRoute(
      path: '/hub/:alias/*',
      redirectTo: '$basePath/:alias',
    ),
    RedirectRoute(
      path: '/hubs/:alias/*',
      redirectTo: '$basePath/:alias/$profile',
    ),
  ];
}
