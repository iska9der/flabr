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
import 'package:flutter/material.dart' as _i6;

import '../../page/articles_page.dart' as _i5;
import '../../page/dashboard_page.dart' as _i1;
import '../../page/news_page.dart' as _i3;
import '../../page/settings_page.dart' as _i4;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
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
    NewsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.NewsPage());
    },
    SettingsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SettingsPage());
    },
    AllArticlesRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.ArticlesPage());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(DashboardRoute.name, path: '/', children: [
          _i2.RouteConfig(ArticlesRoute.name,
              path: 'articles',
              parent: DashboardRoute.name,
              children: [
                _i2.RouteConfig(AllArticlesRoute.name,
                    path: '', parent: ArticlesRoute.name)
              ]),
          _i2.RouteConfig(NewsRoute.name,
              path: 'news', parent: DashboardRoute.name),
          _i2.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: DashboardRoute.name)
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
/// [_i3.NewsPage]
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
/// [_i5.ArticlesPage]
class AllArticlesRoute extends _i2.PageRouteInfo<void> {
  const AllArticlesRoute() : super(AllArticlesRoute.name, path: '');

  static const String name = 'AllArticlesRoute';
}
