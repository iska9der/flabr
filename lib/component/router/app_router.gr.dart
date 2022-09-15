// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    DashboardRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DashboardPage());
    },
    ArticlesEmptyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    NewsEmptyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    ServicesEmptyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SettingsPage());
    },
    ArticleListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleListRouteArgs>(
          orElse: () =>
              ArticleListRouteArgs(flow: pathParams.getString('flow')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ArticleListPage(key: args.key, flow: args.flow));
    },
    ArticleDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleDetailRouteArgs>(
          orElse: () => ArticleDetailRouteArgs(id: pathParams.getString('id')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ArticleDetailPage(key: args.key, id: args.id));
    },
    ArticleCommentListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleCommentListRouteArgs>(
          orElse: () => ArticleCommentListRouteArgs(
              articleId: pathParams.getString('articleId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: CommentListPage(key: args.key, articleId: args.articleId));
    },
    NewsListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewsListRouteArgs>(
          orElse: () => NewsListRouteArgs(flow: pathParams.getString('flow')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: NewsListPage(key: args.key, flow: args.flow));
    },
    NewsDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewsDetailRouteArgs>(
          orElse: () => NewsDetailRouteArgs(id: pathParams.getString('id')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: NewsDetailPage(key: args.key, id: args.id));
    },
    ServicesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ServicesPage());
    },
    HubListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HubListPage());
    },
    HubDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HubDashboardRouteArgs>(
          orElse: () =>
              HubDashboardRouteArgs(alias: pathParams.getString('alias')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: HubDashboardPage(key: args.key, alias: args.alias));
    },
    UserListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const UserListPage());
    },
    UserDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDashboardRouteArgs>(
          orElse: () =>
              UserDashboardRouteArgs(login: pathParams.getString('login')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: UserDashboardPage(key: args.key, login: args.login));
    },
    HubDetailRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HubDetailPage());
    },
    UserDetailRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const UserDetailPage());
    },
    UserArticleListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const UserArticleListPage());
    },
    UserBookmarkListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const UserBookmarkListPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(DashboardRoute.name, path: '/', children: [
          RouteConfig('#redirect',
              path: '',
              parent: DashboardRoute.name,
              redirectTo: 'articles',
              fullMatch: true),
          RouteConfig(ArticlesEmptyRoute.name,
              path: 'articles',
              parent: DashboardRoute.name,
              children: [
                RouteConfig('#redirect',
                    path: '',
                    parent: ArticlesEmptyRoute.name,
                    redirectTo: 'flows/all',
                    fullMatch: true),
                RouteConfig(ArticleListRoute.name,
                    path: 'flows/:flow', parent: ArticlesEmptyRoute.name),
                RouteConfig(ArticleDetailRoute.name,
                    path: 'details/:id', parent: ArticlesEmptyRoute.name),
                RouteConfig(ArticleCommentListRoute.name,
                    path: 'comments/:articleId',
                    parent: ArticlesEmptyRoute.name)
              ]),
          RouteConfig(NewsEmptyRoute.name,
              path: 'news',
              parent: DashboardRoute.name,
              children: [
                RouteConfig('#redirect',
                    path: '',
                    parent: NewsEmptyRoute.name,
                    redirectTo: 'flows/all',
                    fullMatch: true),
                RouteConfig(NewsListRoute.name,
                    path: 'flows/:flow', parent: NewsEmptyRoute.name),
                RouteConfig(NewsDetailRoute.name,
                    path: 'details/:id', parent: NewsEmptyRoute.name)
              ]),
          RouteConfig(ServicesEmptyRoute.name,
              path: 'services',
              parent: DashboardRoute.name,
              children: [
                RouteConfig(ServicesRoute.name,
                    path: '', parent: ServicesEmptyRoute.name),
                RouteConfig(HubListRoute.name,
                    path: 'hubs', parent: ServicesEmptyRoute.name),
                RouteConfig(HubDashboardRoute.name,
                    path: 'hubs/:alias',
                    parent: ServicesEmptyRoute.name,
                    children: [
                      RouteConfig(HubDetailRoute.name,
                          path: 'profile', parent: HubDashboardRoute.name)
                    ]),
                RouteConfig(UserListRoute.name,
                    path: 'users', parent: ServicesEmptyRoute.name),
                RouteConfig(UserDashboardRoute.name,
                    path: 'users/:login',
                    parent: ServicesEmptyRoute.name,
                    children: [
                      RouteConfig(UserDetailRoute.name,
                          path: 'detail', parent: UserDashboardRoute.name),
                      RouteConfig(UserArticleListRoute.name,
                          path: 'article', parent: UserDashboardRoute.name),
                      RouteConfig(UserBookmarkListRoute.name,
                          path: 'bookmarks', parent: UserDashboardRoute.name)
                    ])
              ]),
          RouteConfig(SettingsRoute.name,
              path: 'settings', parent: DashboardRoute.name),
          RouteConfig('*/flows/:flow/news#redirect',
              path: '*/flows/:flow/news',
              parent: DashboardRoute.name,
              redirectTo: 'news/flows/:flow',
              fullMatch: true),
          RouteConfig('*/news/#redirect',
              path: '*/news/',
              parent: DashboardRoute.name,
              redirectTo: 'news',
              fullMatch: true),
          RouteConfig('*/news/t/:id#redirect',
              path: '*/news/t/:id',
              parent: DashboardRoute.name,
              redirectTo: 'news/details/:id',
              fullMatch: true),
          RouteConfig('*/flows/:flow/#redirect',
              path: '*/flows/:flow/',
              parent: DashboardRoute.name,
              redirectTo: 'articles/flows/:flow',
              fullMatch: true),
          RouteConfig('*/post/:id#redirect',
              path: '*/post/:id',
              parent: DashboardRoute.name,
              redirectTo: 'articles/details/:id',
              fullMatch: true),
          RouteConfig('*/post/:id/comments#redirect',
              path: '*/post/:id/comments',
              parent: DashboardRoute.name,
              redirectTo: 'articles/comments/:id',
              fullMatch: true),
          RouteConfig('*/company/*/blog/:id#redirect',
              path: '*/company/*/blog/:id',
              parent: DashboardRoute.name,
              redirectTo: 'articles/details/:id',
              fullMatch: true),
          RouteConfig('*/users#redirect',
              path: '*/users',
              parent: DashboardRoute.name,
              redirectTo: 'services/users',
              fullMatch: true),
          RouteConfig('*/users/:login#redirect',
              path: '*/users/:login',
              parent: DashboardRoute.name,
              redirectTo: 'services/users/:login',
              fullMatch: true),
          RouteConfig('*/users/:login/posts#redirect',
              path: '*/users/:login/posts',
              parent: DashboardRoute.name,
              redirectTo: 'services/users/:login/article',
              fullMatch: true),
          RouteConfig('*/users/:login/favorites#redirect',
              path: '*/users/:login/favorites',
              parent: DashboardRoute.name,
              redirectTo: 'services/users/:login/bookmarks',
              fullMatch: true),
          RouteConfig('*/users/:login/*#redirect',
              path: '*/users/:login/*',
              parent: DashboardRoute.name,
              redirectTo: 'services/users/:login/detail',
              fullMatch: true),
          RouteConfig('*/hubs#redirect',
              path: '*/hubs',
              parent: DashboardRoute.name,
              redirectTo: 'services/hubs',
              fullMatch: true),
          RouteConfig('*/hub/:alias#redirect',
              path: '*/hub/:alias',
              parent: DashboardRoute.name,
              redirectTo: 'services/hubs/:alias/profile',
              fullMatch: true),
          RouteConfig('*/hub/:alias/*#redirect',
              path: '*/hub/:alias/*',
              parent: DashboardRoute.name,
              redirectTo: 'services/hubs/:alias',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(DashboardRoute.name, path: '/', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [EmptyRouterPage]
class ArticlesEmptyRoute extends PageRouteInfo<void> {
  const ArticlesEmptyRoute({List<PageRouteInfo>? children})
      : super(ArticlesEmptyRoute.name,
            path: 'articles', initialChildren: children);

  static const String name = 'ArticlesEmptyRoute';
}

/// generated route for
/// [EmptyRouterPage]
class NewsEmptyRoute extends PageRouteInfo<void> {
  const NewsEmptyRoute({List<PageRouteInfo>? children})
      : super(NewsEmptyRoute.name, path: 'news', initialChildren: children);

  static const String name = 'NewsEmptyRoute';
}

/// generated route for
/// [EmptyRouterPage]
class ServicesEmptyRoute extends PageRouteInfo<void> {
  const ServicesEmptyRoute({List<PageRouteInfo>? children})
      : super(ServicesEmptyRoute.name,
            path: 'services', initialChildren: children);

  static const String name = 'ServicesEmptyRoute';
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [ArticleListPage]
class ArticleListRoute extends PageRouteInfo<ArticleListRouteArgs> {
  ArticleListRoute({Key? key, required String flow})
      : super(ArticleListRoute.name,
            path: 'flows/:flow',
            args: ArticleListRouteArgs(key: key, flow: flow),
            rawPathParams: {'flow': flow});

  static const String name = 'ArticleListRoute';
}

class ArticleListRouteArgs {
  const ArticleListRouteArgs({this.key, required this.flow});

  final Key? key;

  final String flow;

  @override
  String toString() {
    return 'ArticleListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [ArticleDetailPage]
class ArticleDetailRoute extends PageRouteInfo<ArticleDetailRouteArgs> {
  ArticleDetailRoute({Key? key, required String id})
      : super(ArticleDetailRoute.name,
            path: 'details/:id',
            args: ArticleDetailRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ArticleDetailRoute';
}

class ArticleDetailRouteArgs {
  const ArticleDetailRouteArgs({this.key, required this.id});

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'ArticleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [CommentListPage]
class ArticleCommentListRoute
    extends PageRouteInfo<ArticleCommentListRouteArgs> {
  ArticleCommentListRoute({Key? key, required String articleId})
      : super(ArticleCommentListRoute.name,
            path: 'comments/:articleId',
            args: ArticleCommentListRouteArgs(key: key, articleId: articleId),
            rawPathParams: {'articleId': articleId});

  static const String name = 'ArticleCommentListRoute';
}

class ArticleCommentListRouteArgs {
  const ArticleCommentListRouteArgs({this.key, required this.articleId});

  final Key? key;

  final String articleId;

  @override
  String toString() {
    return 'ArticleCommentListRouteArgs{key: $key, articleId: $articleId}';
  }
}

/// generated route for
/// [NewsListPage]
class NewsListRoute extends PageRouteInfo<NewsListRouteArgs> {
  NewsListRoute({Key? key, required String flow})
      : super(NewsListRoute.name,
            path: 'flows/:flow',
            args: NewsListRouteArgs(key: key, flow: flow),
            rawPathParams: {'flow': flow});

  static const String name = 'NewsListRoute';
}

class NewsListRouteArgs {
  const NewsListRouteArgs({this.key, required this.flow});

  final Key? key;

  final String flow;

  @override
  String toString() {
    return 'NewsListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [NewsDetailPage]
class NewsDetailRoute extends PageRouteInfo<NewsDetailRouteArgs> {
  NewsDetailRoute({Key? key, required String id})
      : super(NewsDetailRoute.name,
            path: 'details/:id',
            args: NewsDetailRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'NewsDetailRoute';
}

class NewsDetailRouteArgs {
  const NewsDetailRouteArgs({this.key, required this.id});

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'NewsDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ServicesPage]
class ServicesRoute extends PageRouteInfo<void> {
  const ServicesRoute() : super(ServicesRoute.name, path: '');

  static const String name = 'ServicesRoute';
}

/// generated route for
/// [HubListPage]
class HubListRoute extends PageRouteInfo<void> {
  const HubListRoute() : super(HubListRoute.name, path: 'hubs');

  static const String name = 'HubListRoute';
}

/// generated route for
/// [HubDashboardPage]
class HubDashboardRoute extends PageRouteInfo<HubDashboardRouteArgs> {
  HubDashboardRoute(
      {Key? key, required String alias, List<PageRouteInfo>? children})
      : super(HubDashboardRoute.name,
            path: 'hubs/:alias',
            args: HubDashboardRouteArgs(key: key, alias: alias),
            rawPathParams: {'alias': alias},
            initialChildren: children);

  static const String name = 'HubDashboardRoute';
}

class HubDashboardRouteArgs {
  const HubDashboardRouteArgs({this.key, required this.alias});

  final Key? key;

  final String alias;

  @override
  String toString() {
    return 'HubDashboardRouteArgs{key: $key, alias: $alias}';
  }
}

/// generated route for
/// [UserListPage]
class UserListRoute extends PageRouteInfo<void> {
  const UserListRoute() : super(UserListRoute.name, path: 'users');

  static const String name = 'UserListRoute';
}

/// generated route for
/// [UserDashboardPage]
class UserDashboardRoute extends PageRouteInfo<UserDashboardRouteArgs> {
  UserDashboardRoute(
      {Key? key, required String login, List<PageRouteInfo>? children})
      : super(UserDashboardRoute.name,
            path: 'users/:login',
            args: UserDashboardRouteArgs(key: key, login: login),
            rawPathParams: {'login': login},
            initialChildren: children);

  static const String name = 'UserDashboardRoute';
}

class UserDashboardRouteArgs {
  const UserDashboardRouteArgs({this.key, required this.login});

  final Key? key;

  final String login;

  @override
  String toString() {
    return 'UserDashboardRouteArgs{key: $key, login: $login}';
  }
}

/// generated route for
/// [HubDetailPage]
class HubDetailRoute extends PageRouteInfo<void> {
  const HubDetailRoute() : super(HubDetailRoute.name, path: 'profile');

  static const String name = 'HubDetailRoute';
}

/// generated route for
/// [UserDetailPage]
class UserDetailRoute extends PageRouteInfo<void> {
  const UserDetailRoute() : super(UserDetailRoute.name, path: 'detail');

  static const String name = 'UserDetailRoute';
}

/// generated route for
/// [UserArticleListPage]
class UserArticleListRoute extends PageRouteInfo<void> {
  const UserArticleListRoute()
      : super(UserArticleListRoute.name, path: 'article');

  static const String name = 'UserArticleListRoute';
}

/// generated route for
/// [UserBookmarkListPage]
class UserBookmarkListRoute extends PageRouteInfo<void> {
  const UserBookmarkListRoute()
      : super(UserBookmarkListRoute.name, path: 'bookmarks');

  static const String name = 'UserBookmarkListRoute';
}
