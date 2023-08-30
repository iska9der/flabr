// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ArticleDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleDetailRouteArgs>(
          orElse: () => ArticleDetailRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArticleDetailPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ArticleListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleListRouteArgs>(
          orElse: () =>
              ArticleListRouteArgs(flow: pathParams.getString('flow')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArticleListPage(
          key: args.key,
          flow: args.flow,
        ),
      );
    },
    ArticleCommentListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleCommentListRouteArgs>(
          orElse: () => ArticleCommentListRouteArgs(
              articleId: pathParams.getString('articleId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommentListPage(
          key: args.key,
          articleId: args.articleId,
        ),
      );
    },
    CompanyDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CompanyDashboardRouteArgs>(
          orElse: () =>
              CompanyDashboardRouteArgs(alias: pathParams.getString('alias')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompanyDashboardPage(
          key: args.key,
          alias: args.alias,
        ),
      );
    },
    CompanyDetailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CompanyDetailPage(),
      );
    },
    CompanyListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CompanyListPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    HubDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HubDashboardRouteArgs>(
          orElse: () =>
              HubDashboardRouteArgs(alias: pathParams.getString('alias')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HubDashboardPage(
          key: args.key,
          alias: args.alias,
        ),
      );
    },
    HubDetailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HubDetailPage(),
      );
    },
    HubListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HubListPage(),
      );
    },
    MyArticlesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyArticlesRouteEmpty(),
      );
    },
    MyNewsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyNewsRouteEmpty(),
      );
    },
    MyServicesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyServicesRouteEmpty(),
      );
    },
    MyUsersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyUsersRouteEmpty(),
      );
    },
    NewsDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewsDetailRouteArgs>(
          orElse: () => NewsDetailRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsDetailPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    NewsListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewsListRouteArgs>(
          orElse: () => NewsListRouteArgs(flow: pathParams.getString('flow')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsListPage(
          key: args.key,
          flow: args.flow,
        ),
      );
    },
    ServicesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServicesPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    UserArticleListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserArticleListPage(),
      );
    },
    UserBookmarkListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserBookmarkListPage(),
      );
    },
    UserDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDashboardRouteArgs>(
          orElse: () =>
              UserDashboardRouteArgs(login: pathParams.getString('login')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserDashboardPage(
          key: args.key,
          login: args.login,
        ),
      );
    },
    UserDetailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserDetailPage(),
      );
    },
    UserListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserListPage(),
      );
    },
  };
}

/// generated route for
/// [ArticleDetailPage]
class ArticleDetailRoute extends PageRouteInfo<ArticleDetailRouteArgs> {
  ArticleDetailRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          ArticleDetailRoute.name,
          args: ArticleDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ArticleDetailRoute';

  static const PageInfo<ArticleDetailRouteArgs> page =
      PageInfo<ArticleDetailRouteArgs>(name);
}

class ArticleDetailRouteArgs {
  const ArticleDetailRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'ArticleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ArticleListPage]
class ArticleListRoute extends PageRouteInfo<ArticleListRouteArgs> {
  ArticleListRoute({
    Key? key,
    required String flow,
    List<PageRouteInfo>? children,
  }) : super(
          ArticleListRoute.name,
          args: ArticleListRouteArgs(
            key: key,
            flow: flow,
          ),
          rawPathParams: {'flow': flow},
          initialChildren: children,
        );

  static const String name = 'ArticleListRoute';

  static const PageInfo<ArticleListRouteArgs> page =
      PageInfo<ArticleListRouteArgs>(name);
}

class ArticleListRouteArgs {
  const ArticleListRouteArgs({
    this.key,
    required this.flow,
  });

  final Key? key;

  final String flow;

  @override
  String toString() {
    return 'ArticleListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [CommentListPage]
class ArticleCommentListRoute
    extends PageRouteInfo<ArticleCommentListRouteArgs> {
  ArticleCommentListRoute({
    Key? key,
    required String articleId,
    List<PageRouteInfo>? children,
  }) : super(
          ArticleCommentListRoute.name,
          args: ArticleCommentListRouteArgs(
            key: key,
            articleId: articleId,
          ),
          rawPathParams: {'articleId': articleId},
          initialChildren: children,
        );

  static const String name = 'ArticleCommentListRoute';

  static const PageInfo<ArticleCommentListRouteArgs> page =
      PageInfo<ArticleCommentListRouteArgs>(name);
}

class ArticleCommentListRouteArgs {
  const ArticleCommentListRouteArgs({
    this.key,
    required this.articleId,
  });

  final Key? key;

  final String articleId;

  @override
  String toString() {
    return 'ArticleCommentListRouteArgs{key: $key, articleId: $articleId}';
  }
}

/// generated route for
/// [CompanyDashboardPage]
class CompanyDashboardRoute extends PageRouteInfo<CompanyDashboardRouteArgs> {
  CompanyDashboardRoute({
    Key? key,
    required String alias,
    List<PageRouteInfo>? children,
  }) : super(
          CompanyDashboardRoute.name,
          args: CompanyDashboardRouteArgs(
            key: key,
            alias: alias,
          ),
          rawPathParams: {'alias': alias},
          initialChildren: children,
        );

  static const String name = 'CompanyDashboardRoute';

  static const PageInfo<CompanyDashboardRouteArgs> page =
      PageInfo<CompanyDashboardRouteArgs>(name);
}

class CompanyDashboardRouteArgs {
  const CompanyDashboardRouteArgs({
    this.key,
    required this.alias,
  });

  final Key? key;

  final String alias;

  @override
  String toString() {
    return 'CompanyDashboardRouteArgs{key: $key, alias: $alias}';
  }
}

/// generated route for
/// [CompanyDetailPage]
class CompanyDetailRoute extends PageRouteInfo<void> {
  const CompanyDetailRoute({List<PageRouteInfo>? children})
      : super(
          CompanyDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'CompanyDetailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CompanyListPage]
class CompanyListRoute extends PageRouteInfo<void> {
  const CompanyListRoute({List<PageRouteInfo>? children})
      : super(
          CompanyListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CompanyListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HubDashboardPage]
class HubDashboardRoute extends PageRouteInfo<HubDashboardRouteArgs> {
  HubDashboardRoute({
    Key? key,
    required String alias,
    List<PageRouteInfo>? children,
  }) : super(
          HubDashboardRoute.name,
          args: HubDashboardRouteArgs(
            key: key,
            alias: alias,
          ),
          rawPathParams: {'alias': alias},
          initialChildren: children,
        );

  static const String name = 'HubDashboardRoute';

  static const PageInfo<HubDashboardRouteArgs> page =
      PageInfo<HubDashboardRouteArgs>(name);
}

class HubDashboardRouteArgs {
  const HubDashboardRouteArgs({
    this.key,
    required this.alias,
  });

  final Key? key;

  final String alias;

  @override
  String toString() {
    return 'HubDashboardRouteArgs{key: $key, alias: $alias}';
  }
}

/// generated route for
/// [HubDetailPage]
class HubDetailRoute extends PageRouteInfo<void> {
  const HubDetailRoute({List<PageRouteInfo>? children})
      : super(
          HubDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'HubDetailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HubListPage]
class HubListRoute extends PageRouteInfo<void> {
  const HubListRoute({List<PageRouteInfo>? children})
      : super(
          HubListRoute.name,
          initialChildren: children,
        );

  static const String name = 'HubListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyArticlesRouteEmpty]
class MyArticlesRoute extends PageRouteInfo<void> {
  const MyArticlesRoute({List<PageRouteInfo>? children})
      : super(
          MyArticlesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyArticlesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyNewsRouteEmpty]
class MyNewsRoute extends PageRouteInfo<void> {
  const MyNewsRoute({List<PageRouteInfo>? children})
      : super(
          MyNewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyNewsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyServicesRouteEmpty]
class MyServicesRoute extends PageRouteInfo<void> {
  const MyServicesRoute({List<PageRouteInfo>? children})
      : super(
          MyServicesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyServicesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyUsersRouteEmpty]
class MyUsersRoute extends PageRouteInfo<void> {
  const MyUsersRoute({List<PageRouteInfo>? children})
      : super(
          MyUsersRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyUsersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewsDetailPage]
class NewsDetailRoute extends PageRouteInfo<NewsDetailRouteArgs> {
  NewsDetailRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          NewsDetailRoute.name,
          args: NewsDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'NewsDetailRoute';

  static const PageInfo<NewsDetailRouteArgs> page =
      PageInfo<NewsDetailRouteArgs>(name);
}

class NewsDetailRouteArgs {
  const NewsDetailRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'NewsDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [NewsListPage]
class NewsListRoute extends PageRouteInfo<NewsListRouteArgs> {
  NewsListRoute({
    Key? key,
    required String flow,
    List<PageRouteInfo>? children,
  }) : super(
          NewsListRoute.name,
          args: NewsListRouteArgs(
            key: key,
            flow: flow,
          ),
          rawPathParams: {'flow': flow},
          initialChildren: children,
        );

  static const String name = 'NewsListRoute';

  static const PageInfo<NewsListRouteArgs> page =
      PageInfo<NewsListRouteArgs>(name);
}

class NewsListRouteArgs {
  const NewsListRouteArgs({
    this.key,
    required this.flow,
  });

  final Key? key;

  final String flow;

  @override
  String toString() {
    return 'NewsListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [ServicesPage]
class ServicesRoute extends PageRouteInfo<void> {
  const ServicesRoute({List<PageRouteInfo>? children})
      : super(
          ServicesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServicesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserArticleListPage]
class UserArticleListRoute extends PageRouteInfo<void> {
  const UserArticleListRoute({List<PageRouteInfo>? children})
      : super(
          UserArticleListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserArticleListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserBookmarkListPage]
class UserBookmarkListRoute extends PageRouteInfo<void> {
  const UserBookmarkListRoute({List<PageRouteInfo>? children})
      : super(
          UserBookmarkListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserBookmarkListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserDashboardPage]
class UserDashboardRoute extends PageRouteInfo<UserDashboardRouteArgs> {
  UserDashboardRoute({
    Key? key,
    required String login,
    List<PageRouteInfo>? children,
  }) : super(
          UserDashboardRoute.name,
          args: UserDashboardRouteArgs(
            key: key,
            login: login,
          ),
          rawPathParams: {'login': login},
          initialChildren: children,
        );

  static const String name = 'UserDashboardRoute';

  static const PageInfo<UserDashboardRouteArgs> page =
      PageInfo<UserDashboardRouteArgs>(name);
}

class UserDashboardRouteArgs {
  const UserDashboardRouteArgs({
    this.key,
    required this.login,
  });

  final Key? key;

  final String login;

  @override
  String toString() {
    return 'UserDashboardRouteArgs{key: $key, login: $login}';
  }
}

/// generated route for
/// [UserDetailPage]
class UserDetailRoute extends PageRouteInfo<void> {
  const UserDetailRoute({List<PageRouteInfo>? children})
      : super(
          UserDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserDetailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserListPage]
class UserListRoute extends PageRouteInfo<void> {
  const UserListRoute({List<PageRouteInfo>? children})
      : super(
          UserListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
