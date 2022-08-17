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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../page/articles_page.dart' as _i2;
import '../../page/news_page.dart' as _i3;
import '../../page/settings_page.dart' as _i4;
import '../../page/wrapper_widget.dart' as _i1;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    WrapperRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.WrapperPage());
    },
    ArticlesRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.ArticlesPage());
    },
    NewsRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.NewsPage());
    },
    SettingsRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SettingsPage());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(WrapperRoute.name, path: '/', children: [
          _i5.RouteConfig(ArticlesRoute.name,
              path: 'article', parent: WrapperRoute.name),
          _i5.RouteConfig(NewsRoute.name,
              path: 'news', parent: WrapperRoute.name),
          _i5.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: WrapperRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.WrapperPage]
class WrapperRoute extends _i5.PageRouteInfo<void> {
  const WrapperRoute({List<_i5.PageRouteInfo>? children})
      : super(WrapperRoute.name, path: '/', initialChildren: children);

  static const String name = 'WrapperRoute';
}

/// generated route for
/// [_i2.ArticlesPage]
class ArticlesRoute extends _i5.PageRouteInfo<void> {
  const ArticlesRoute() : super(ArticlesRoute.name, path: 'article');

  static const String name = 'ArticlesRoute';
}

/// generated route for
/// [_i3.NewsPage]
class NewsRoute extends _i5.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: 'news');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i5.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}
