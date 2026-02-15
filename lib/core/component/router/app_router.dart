part of 'router.dart';

@Singleton()
// ignore: avoid_redundant_argument_values
@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
// extend the generated private router
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    CustomRoute(
      page: SplashRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),

    AutoRoute(
      page: DashboardRoute.page,
      initial: true,
      guards: [SplashGuard()],
      path: '/',
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
            AutoRoute(page: HubListRoute.page, path: HubListPage.routePath),
            _hubDashboard(),

            /// Пользователи/Авторы
            AutoRoute(page: UserListRoute.page, path: UserListPage.routePath),
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
        AutoRoute(page: SettingsRoute.page, path: SettingsPage.routePath),
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

    AutoRoute(
      page: ProfileDashboardRoute.page,
      path: ProfileDashboardPage.routePath,
      children: _userChildren,
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

List<AutoRoute> get _userChildren => [
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
];

AutoRoute _userDashboard({bool isRoot = false}) => AutoRoute(
  page: UserDashboardRoute.page,
  path: "${isRoot == true ? '/' : ''}${UserDashboardPage.routePath}",
  children: _userChildren,
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
  List<String> externalPathList = [
    '/news/:id',
    '/news/t/:id',
    '/companies/:companyName/news/:id',
  ];

  List<RedirectRoute> internalRedirectList = externalPathList
      .map(
        (path) => [
          RedirectRoute(path: path, redirectTo: '/publication/news/:id'),
          RedirectRoute(
            path: '$path/comments',
            redirectTo: '/publication/news/:id/comments',
          ),
        ],
      )
      .flattened
      .toList();

  return [
    /// Флоу в новостях
    RedirectRoute(path: '/flows/:flow/news', redirectTo: '/news/flows/:flow'),

    /// Новости
    RedirectRoute(path: '/news/', redirectTo: '/news'),

    /// Полная новость и комментарии
    ...internalRedirectList,
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

    /// AMP ссылки
    '/amp/publications/:id',
  ];

  List<RedirectRoute> internalRedirectList = externalPathList
      .map(
        (path) => [
          RedirectRoute(path: path, redirectTo: '/publication/article/:id'),
          RedirectRoute(
            path: '$path/comments',
            redirectTo: '/publication/article/:id/comments',
          ),
        ],
      )
      .flattened
      .toList();

  return [
    /// Флоу в статьях
    RedirectRoute(path: '/flows/:flow/', redirectTo: '/articles/flows/:flow'),
    RedirectRoute(
      path: '/flows/:flow/articles',
      redirectTo: '/articles/flows/:flow',
    ),

    /// Статьи
    RedirectRoute(path: '/articles/', redirectTo: '/articles'),

    /// Полная статья и комментарии
    ...internalRedirectList,
  ];
}

List<RedirectRoute> _postsRedirects() {
  List<String> externalPathList = [
    '/posts/:id',
    '/companies/:companyName/posts/:id',
  ];

  List<RedirectRoute> internalRedirectList = externalPathList
      .map(
        (path) => [
          RedirectRoute(path: path, redirectTo: '/publication/post/:id'),
          RedirectRoute(
            path: '$path/comments',
            redirectTo: '/publication/post/:id/comments',
          ),
        ],
      )
      .flattened
      .toList();

  return [
    /// Флоу в постах
    RedirectRoute(path: '/flows/:flow/posts', redirectTo: '/posts/flows/:flow'),

    /// Посты
    RedirectRoute(path: '/posts/', redirectTo: '/posts'),

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
    RedirectRoute(path: '/users', redirectTo: basePath),

    /// Пользователь
    RedirectRoute(path: '/users/:login', redirectTo: '$basePath/:login'),

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
  const hubListPath = HubListPage.routePath;
  const fullPath = '/services/$hubListPath';
  const profilePath = HubDetailPage.routePath;

  return [
    RedirectRoute(path: '/hubs', redirectTo: fullPath),
    RedirectRoute(
      path: '/hub/:alias',
      redirectTo: '$fullPath/:alias/$profilePath',
    ),
    RedirectRoute(
      path: '/hubs/:alias',
      redirectTo: '$fullPath/:alias/$profilePath',
    ),

    /// TODO: временный редирект в профиль хаба со статьями,
    /// пока не реализованы вложенные разделы
    /// (авторы, компании)
    RedirectRoute(path: '/hub/:alias/*', redirectTo: '$fullPath/:alias'),
    RedirectRoute(
      path: '/hubs/:alias/*',
      redirectTo: '$fullPath/:alias/$profilePath',
    ),
  ];
}
