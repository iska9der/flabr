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
    ArticleCommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ArticleCommentsRouteArgs>(
          orElse: () =>
              ArticleCommentsRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArticleCommentListPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
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
    ArticlesRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArticlesRouterData(),
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
    NewsCommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewsCommentsRouteArgs>(
          orElse: () => NewsCommentsRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsCommentListPage(
          key: args.key,
          id: args.id,
        ),
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
    NewsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsRouterData(),
      );
    },
    PostCommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostCommentsRouteArgs>(
          orElse: () => PostCommentsRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostCommentListPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    PostDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostDetailRouteArgs>(
          orElse: () => PostDetailRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostDetailPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    PostListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostListRouteArgs>(
          orElse: () => PostListRouteArgs(flow: pathParams.getString('flow')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostListPage(
          key: args.key,
          flow: args.flow,
        ),
      );
    },
    PostsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostsRouterData(),
      );
    },
    PublicationsDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PublicationDashboardPage(),
      );
    },
    ServicesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServicesPage(),
      );
    },
    ServicesRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServicesRouterData(),
      );
    },
    SettingsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
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
    UserPublicationListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserPublicationListPage(),
      );
    },
  };
}

/// generated route for
/// [ArticleCommentListPage]
class ArticleCommentsRoute extends PageRouteInfo<ArticleCommentsRouteArgs> {
  ArticleCommentsRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          ArticleCommentsRoute.name,
          args: ArticleCommentsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ArticleCommentsRoute';

  static const PageInfo<ArticleCommentsRouteArgs> page =
      PageInfo<ArticleCommentsRouteArgs>(name);
}

class ArticleCommentsRouteArgs {
  const ArticleCommentsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'ArticleCommentsRouteArgs{key: $key, id: $id}';
  }
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
/// [ArticlesRouterData]
class ArticlesRouter extends PageRouteInfo<void> {
  const ArticlesRouter({List<PageRouteInfo>? children})
      : super(
          ArticlesRouter.name,
          initialChildren: children,
        );

  static const String name = 'ArticlesRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [NewsCommentListPage]
class NewsCommentsRoute extends PageRouteInfo<NewsCommentsRouteArgs> {
  NewsCommentsRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          NewsCommentsRoute.name,
          args: NewsCommentsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'NewsCommentsRoute';

  static const PageInfo<NewsCommentsRouteArgs> page =
      PageInfo<NewsCommentsRouteArgs>(name);
}

class NewsCommentsRouteArgs {
  const NewsCommentsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'NewsCommentsRouteArgs{key: $key, id: $id}';
  }
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
/// [NewsRouterData]
class NewsRouter extends PageRouteInfo<void> {
  const NewsRouter({List<PageRouteInfo>? children})
      : super(
          NewsRouter.name,
          initialChildren: children,
        );

  static const String name = 'NewsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PostCommentListPage]
class PostCommentsRoute extends PageRouteInfo<PostCommentsRouteArgs> {
  PostCommentsRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PostCommentsRoute.name,
          args: PostCommentsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'PostCommentsRoute';

  static const PageInfo<PostCommentsRouteArgs> page =
      PageInfo<PostCommentsRouteArgs>(name);
}

class PostCommentsRouteArgs {
  const PostCommentsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'PostCommentsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [PostDetailPage]
class PostDetailRoute extends PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PostDetailRoute.name,
          args: PostDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'PostDetailRoute';

  static const PageInfo<PostDetailRouteArgs> page =
      PageInfo<PostDetailRouteArgs>(name);
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'PostDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [PostListPage]
class PostListRoute extends PageRouteInfo<PostListRouteArgs> {
  PostListRoute({
    Key? key,
    required String flow,
    List<PageRouteInfo>? children,
  }) : super(
          PostListRoute.name,
          args: PostListRouteArgs(
            key: key,
            flow: flow,
          ),
          rawPathParams: {'flow': flow},
          initialChildren: children,
        );

  static const String name = 'PostListRoute';

  static const PageInfo<PostListRouteArgs> page =
      PageInfo<PostListRouteArgs>(name);
}

class PostListRouteArgs {
  const PostListRouteArgs({
    this.key,
    required this.flow,
  });

  final Key? key;

  final String flow;

  @override
  String toString() {
    return 'PostListRouteArgs{key: $key, flow: $flow}';
  }
}

/// generated route for
/// [PostsRouterData]
class PostsRouter extends PageRouteInfo<void> {
  const PostsRouter({List<PageRouteInfo>? children})
      : super(
          PostsRouter.name,
          initialChildren: children,
        );

  static const String name = 'PostsRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PublicationDashboardPage]
class PublicationsDashboardRoute extends PageRouteInfo<void> {
  const PublicationsDashboardRoute({List<PageRouteInfo>? children})
      : super(
          PublicationsDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'PublicationsDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [ServicesRouterData]
class ServicesRouter extends PageRouteInfo<void> {
  const ServicesRouter({List<PageRouteInfo>? children})
      : super(
          ServicesRouter.name,
          initialChildren: children,
        );

  static const String name = 'ServicesRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRouter extends PageRouteInfo<void> {
  const SettingsRouter({List<PageRouteInfo>? children})
      : super(
          SettingsRouter.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRouter';

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

/// generated route for
/// [UserPublicationListPage]
class UserPublicationListRoute extends PageRouteInfo<void> {
  const UserPublicationListRoute({List<PageRouteInfo>? children})
      : super(
          UserPublicationListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserPublicationListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
