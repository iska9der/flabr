// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i10;

import '../../page/articles/article_detail_page.dart' as _i6;
import '../../page/articles/article_list_page.dart' as _i5;
import '../../page/dashboard_page.dart' as _i1;
import '../../page/news/news_list_page.dart' as _i3;
import '../../page/services_page.dart' as _i7;
import '../../page/settings_page.dart' as _i4;
import '../../page/users/user_detail_page.dart' as _i9;
import '../../page/users/user_list_page.dart' as _i8;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    DashboardRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.DashboardPage());
    },
    ArticlesRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    ServicesRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    NewsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.NewsListPage());
    },
    SettingsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SettingsPage());
    },
    ArticleListRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ArticleListRouteArgs>(
          orElse: () =>
              ArticleListRouteArgs(flow: queryParams.getString('flow', 'all')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.ArticleListPage(key: args.key, flow: args.flow));
    },
    ArticleDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleDetailRouteArgs>(
          orElse: () => ArticleDetailRouteArgs(id: pathParams.getString('id')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.ArticleDetailPage(key: args.key, id: args.id));
    },
    AllServicesRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ServicesPage());
    },
    UserListRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.UserListPage());
    },
    UserDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDetailRouteArgs>(
          orElse: () =>
              UserDetailRouteArgs(login: pathParams.getString('login')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.UserDetailPage(key: args.key, login: args.login));
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(DashboardRoute.name, path: '/', children: [
          _i2.RouteConfig('#redirect',
              path: '',
              parent: DashboardRoute.name,
              redirectTo: 'articles',
              fullMatch: true),
          _i2.RouteConfig(ArticlesRoute.name,
              path: 'articles',
              parent: DashboardRoute.name,
              children: [
                _i2.RouteConfig(ArticleListRoute.name,
                    path: '', parent: ArticlesRoute.name),
                _i2.RouteConfig(ArticleDetailRoute.name,
                    path: ':id', parent: ArticlesRoute.name)
              ]),
          _i2.RouteConfig(ServicesRoute.name,
              path: 'services',
              parent: DashboardRoute.name,
              children: [
                _i2.RouteConfig(AllServicesRoute.name,
                    path: '', parent: ServicesRoute.name),
                _i2.RouteConfig(UserListRoute.name,
                    path: 'users', parent: ServicesRoute.name),
                _i2.RouteConfig(UserDetailRoute.name,
                    path: 'users/:login', parent: ServicesRoute.name)
              ]),
          _i2.RouteConfig(NewsRoute.name,
              path: 'news', parent: DashboardRoute.name),
          _i2.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: DashboardRoute.name),
          _i2.RouteConfig('*/post/:id#redirect',
              path: '*/post/:id',
              parent: DashboardRoute.name,
              redirectTo: 'articles/:id',
              fullMatch: true),
          _i2.RouteConfig('*/flows/:flow#redirect',
              path: '*/flows/:flow',
              parent: DashboardRoute.name,
              redirectTo: 'articles?flow=:flow',
              fullMatch: true),
          _i2.RouteConfig('*/users#redirect',
              path: '*/users',
              parent: DashboardRoute.name,
              redirectTo: 'services/users',
              fullMatch: true),
          _i2.RouteConfig('*/users/:login#redirect',
              path: '*/users/:login',
              parent: DashboardRoute.name,
              redirectTo: 'services/users/:login',
              fullMatch: true),
          _i2.RouteConfig('*/news#redirect',
              path: '*/news',
              parent: DashboardRoute.name,
              redirectTo: 'news',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [_i1.DashboardPage]
class DashboardRoute extends _i2.PageRouteInfo<void> {
  const DashboardRoute({List<_i2.PageRouteInfo>? children})
      : super(DashboardRoute.name, path: '/', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class ArticlesRoute extends _i2.PageRouteInfo<void> {
  const ArticlesRoute({List<_i2.PageRouteInfo>? children})
      : super(ArticlesRoute.name, path: 'articles', initialChildren: children);

  static const String name = 'ArticlesRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class ServicesRoute extends _i2.PageRouteInfo<void> {
  const ServicesRoute({List<_i2.PageRouteInfo>? children})
      : super(ServicesRoute.name, path: 'services', initialChildren: children);

  static const String name = 'ServicesRoute';
}

/// generated route for
/// [_i3.NewsListPage]
class NewsRoute extends _i2.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: 'news');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i2.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i5.ArticleListPage]
class ArticleListRoute extends _i2.PageRouteInfo<ArticleListRouteArgs> {
  ArticleListRoute({_i10.Key? key, String flow = 'all'})
      : super(ArticleListRoute.name,
            path: '',
            args: ArticleListRouteArgs(key: key, flow: flow),
            rawQueryParams: {'flow': flow});

  static const String name = 'ArticleListRoute';
}

class ArticleListRouteArgs {
  const ArticleListRouteArgs({this.key, this.flow = 'all'});

  final _i10.Key? key;

  final String flow;

  @override
  String toString() {
    return 'ArticleListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [_i6.ArticleDetailPage]
class ArticleDetailRoute extends _i2.PageRouteInfo<ArticleDetailRouteArgs> {
  ArticleDetailRoute({_i10.Key? key, required String id})
      : super(ArticleDetailRoute.name,
            path: ':id',
            args: ArticleDetailRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ArticleDetailRoute';
}

class ArticleDetailRouteArgs {
  const ArticleDetailRouteArgs({this.key, required this.id});

  final _i10.Key? key;

  final String id;

  @override
  String toString() {
    return 'ArticleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i7.ServicesPage]
class AllServicesRoute extends _i2.PageRouteInfo<void> {
  const AllServicesRoute() : super(AllServicesRoute.name, path: '');

  static const String name = 'AllServicesRoute';
}

/// generated route for
/// [_i8.UserListPage]
class UserListRoute extends _i2.PageRouteInfo<void> {
  const UserListRoute() : super(UserListRoute.name, path: 'users');

  static const String name = 'UserListRoute';
}

/// generated route for
/// [_i9.UserDetailPage]
class UserDetailRoute extends _i2.PageRouteInfo<UserDetailRouteArgs> {
  UserDetailRoute({_i10.Key? key, required String login})
      : super(UserDetailRoute.name,
            path: 'users/:login',
            args: UserDetailRouteArgs(key: key, login: login),
            rawPathParams: {'login': login});

  static const String name = 'UserDetailRoute';
}

class UserDetailRouteArgs {
  const UserDetailRouteArgs({this.key, required this.login});

  final _i10.Key? key;

  final String login;

  @override
  String toString() {
    return 'UserDetailRouteArgs{key: $key, login: $login}';
  }
}
