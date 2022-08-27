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
    ServicesEmptyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    NewsEmptyRoute.name: (routeData) {
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
    ServicesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ServicesPage());
    },
    UserListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const UserListPage());
    },
    UserDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDetailRouteArgs>(
          orElse: () =>
              UserDetailRouteArgs(login: pathParams.getString('login')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: UserDetailPage(key: args.key, login: args.login));
    },
    NewsListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NewsListPage());
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
                    path: 'details/:id', parent: ArticlesEmptyRoute.name)
              ]),
          RouteConfig(ServicesEmptyRoute.name,
              path: 'services',
              parent: DashboardRoute.name,
              children: [
                RouteConfig(ServicesRoute.name,
                    path: '', parent: ServicesEmptyRoute.name),
                RouteConfig(UserListRoute.name,
                    path: 'users', parent: ServicesEmptyRoute.name),
                RouteConfig(UserDetailRoute.name,
                    path: 'users/:login', parent: ServicesEmptyRoute.name)
              ]),
          RouteConfig(NewsEmptyRoute.name,
              path: 'news',
              parent: DashboardRoute.name,
              children: [
                RouteConfig(NewsListRoute.name,
                    path: '', parent: NewsEmptyRoute.name)
              ]),
          RouteConfig(SettingsRoute.name,
              path: 'settings', parent: DashboardRoute.name),
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
          RouteConfig('*/news/#redirect',
              path: '*/news/',
              parent: DashboardRoute.name,
              redirectTo: 'news',
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
class ServicesEmptyRoute extends PageRouteInfo<void> {
  const ServicesEmptyRoute({List<PageRouteInfo>? children})
      : super(ServicesEmptyRoute.name,
            path: 'services', initialChildren: children);

  static const String name = 'ServicesEmptyRoute';
}

/// generated route for
/// [EmptyRouterPage]
class NewsEmptyRoute extends PageRouteInfo<void> {
  const NewsEmptyRoute({List<PageRouteInfo>? children})
      : super(NewsEmptyRoute.name, path: 'news', initialChildren: children);

  static const String name = 'NewsEmptyRoute';
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
/// [ServicesPage]
class ServicesRoute extends PageRouteInfo<void> {
  const ServicesRoute() : super(ServicesRoute.name, path: '');

  static const String name = 'ServicesRoute';
}

/// generated route for
/// [UserListPage]
class UserListRoute extends PageRouteInfo<void> {
  const UserListRoute() : super(UserListRoute.name, path: 'users');

  static const String name = 'UserListRoute';
}

/// generated route for
/// [UserDetailPage]
class UserDetailRoute extends PageRouteInfo<UserDetailRouteArgs> {
  UserDetailRoute({Key? key, required String login})
      : super(UserDetailRoute.name,
            path: 'users/:login',
            args: UserDetailRouteArgs(key: key, login: login),
            rawPathParams: {'login': login});

  static const String name = 'UserDetailRoute';
}

class UserDetailRouteArgs {
  const UserDetailRouteArgs({this.key, required this.login});

  final Key? key;

  final String login;

  @override
  String toString() {
    return 'UserDetailRouteArgs{key: $key, login: $login}';
  }
}

/// generated route for
/// [NewsListPage]
class NewsListRoute extends PageRouteInfo<void> {
  const NewsListRoute() : super(NewsListRoute.name, path: '');

  static const String name = 'NewsListRoute';
}
