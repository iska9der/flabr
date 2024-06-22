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
        child: ArticlesFlow(),
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
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CompanyDetailRouteArgs>(
          orElse: () => CompanyDetailRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompanyDetailPage(
          key: args.key,
          alias: pathParams.getString('alias'),
        ),
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
    FeedRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FeedFlow(),
      );
    },
    FeedListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FeedListPage(),
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
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HubDetailRouteArgs>(
          orElse: () => HubDetailRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HubDetailPage(
          key: args.key,
          alias: pathParams.getString('alias'),
        ),
      );
    },
    HubListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HubListPage(),
      );
    },
    NewsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsFlow(),
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
        child: PostsFlow(),
      );
    },
    PublicationCommentRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicationCommentRouteArgs>(
          orElse: () => PublicationCommentRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PublicationCommentPage(
          key: args.key,
          type: pathParams.getString('type'),
          id: pathParams.getString('id'),
        ),
      );
    },
    PublicationDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PublicationDashboardPage(),
      );
    },
    PublicationDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicationDetailRouteArgs>(
          orElse: () => PublicationDetailRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PublicationDetailPage(
          key: args.key,
          type: pathParams.getString('type'),
          id: pathParams.getString('id'),
        ),
      );
    },
    PublicationRouter.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicationRouterArgs>(
          orElse: () => PublicationRouterArgs(
                type: pathParams.getString('type'),
                id: pathParams.getString('id'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PublicationFlow(
          key: args.key,
          type: args.type,
          id: args.id,
        ),
      );
    },
    SearchAnywhereRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchAnywherePage(),
      );
    },
    ServicesRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServicesFlow(),
      );
    },
    ServicesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServicesPage(),
      );
    },
    SettingsRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    TrackerDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackerDashboardPage(),
      );
    },
    TrackerPublicationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackerPublicationsPage(),
      );
    },
    TrackerSubscriptionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackerSubscriptionPage(),
      );
    },
    TrackerSystemRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrackerSystemPage(),
      );
    },
    UserBookmarkListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserBookmarkListRouteArgs>(
          orElse: () => UserBookmarkListRouteArgs(
                  type: pathParams.getString(
                'type',
                '',
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserBookmarkListPage(
          key: args.key,
          alias: pathParams.getString('alias'),
          type: args.type,
        ),
      );
    },
    UserCommentListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserCommentListRouteArgs>(
          orElse: () => UserCommentListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserCommentListPage(
          key: args.key,
          alias: pathParams.getString('alias'),
        ),
      );
    },
    UserDashboardRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDashboardRouteArgs>(
          orElse: () =>
              UserDashboardRouteArgs(alias: pathParams.getString('alias')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserDashboardPage(
          key: args.key,
          alias: args.alias,
        ),
      );
    },
    UserDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserDetailRouteArgs>(
          orElse: () => UserDetailRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserDetailPage(
          key: args.key,
          alias: pathParams.getString('alias'),
        ),
      );
    },
    UserListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserListPage(),
      );
    },
    UserPublicationListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicationListRouteArgs>(
          orElse: () => UserPublicationListRouteArgs(
                  type: pathParams.getString(
                'type',
                '',
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPublicationListPage(
          key: args.key,
          alias: pathParams.getString('alias'),
          type: args.type,
        ),
      );
    },
  };
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
/// [ArticlesFlow]
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
class CompanyDetailRoute extends PageRouteInfo<CompanyDetailRouteArgs> {
  CompanyDetailRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CompanyDetailRoute.name,
          args: CompanyDetailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CompanyDetailRoute';

  static const PageInfo<CompanyDetailRouteArgs> page =
      PageInfo<CompanyDetailRouteArgs>(name);
}

class CompanyDetailRouteArgs {
  const CompanyDetailRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CompanyDetailRouteArgs{key: $key}';
  }
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
/// [FeedFlow]
class FeedRouter extends PageRouteInfo<void> {
  const FeedRouter({List<PageRouteInfo>? children})
      : super(
          FeedRouter.name,
          initialChildren: children,
        );

  static const String name = 'FeedRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FeedListPage]
class FeedListRoute extends PageRouteInfo<void> {
  const FeedListRoute({List<PageRouteInfo>? children})
      : super(
          FeedListRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedListRoute';

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
class HubDetailRoute extends PageRouteInfo<HubDetailRouteArgs> {
  HubDetailRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HubDetailRoute.name,
          args: HubDetailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HubDetailRoute';

  static const PageInfo<HubDetailRouteArgs> page =
      PageInfo<HubDetailRouteArgs>(name);
}

class HubDetailRouteArgs {
  const HubDetailRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HubDetailRouteArgs{key: $key}';
  }
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
/// [NewsFlow]
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
/// [PostsFlow]
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
/// [PublicationCommentPage]
class PublicationCommentRoute
    extends PageRouteInfo<PublicationCommentRouteArgs> {
  PublicationCommentRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PublicationCommentRoute.name,
          args: PublicationCommentRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'PublicationCommentRoute';

  static const PageInfo<PublicationCommentRouteArgs> page =
      PageInfo<PublicationCommentRouteArgs>(name);
}

class PublicationCommentRouteArgs {
  const PublicationCommentRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PublicationCommentRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PublicationDashboardPage]
class PublicationDashboardRoute extends PageRouteInfo<void> {
  const PublicationDashboardRoute({List<PageRouteInfo>? children})
      : super(
          PublicationDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'PublicationDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PublicationDetailPage]
class PublicationDetailRoute extends PageRouteInfo<PublicationDetailRouteArgs> {
  PublicationDetailRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PublicationDetailRoute.name,
          args: PublicationDetailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'PublicationDetailRoute';

  static const PageInfo<PublicationDetailRouteArgs> page =
      PageInfo<PublicationDetailRouteArgs>(name);
}

class PublicationDetailRouteArgs {
  const PublicationDetailRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PublicationDetailRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PublicationFlow]
class PublicationRouter extends PageRouteInfo<PublicationRouterArgs> {
  PublicationRouter({
    Key? key,
    required String type,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PublicationRouter.name,
          args: PublicationRouterArgs(
            key: key,
            type: type,
            id: id,
          ),
          rawPathParams: {
            'type': type,
            'id': id,
          },
          initialChildren: children,
        );

  static const String name = 'PublicationRouter';

  static const PageInfo<PublicationRouterArgs> page =
      PageInfo<PublicationRouterArgs>(name);
}

class PublicationRouterArgs {
  const PublicationRouterArgs({
    this.key,
    required this.type,
    required this.id,
  });

  final Key? key;

  final String type;

  final String id;

  @override
  String toString() {
    return 'PublicationRouterArgs{key: $key, type: $type, id: $id}';
  }
}

/// generated route for
/// [SearchAnywherePage]
class SearchAnywhereRoute extends PageRouteInfo<void> {
  const SearchAnywhereRoute({List<PageRouteInfo>? children})
      : super(
          SearchAnywhereRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchAnywhereRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServicesFlow]
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
/// [TrackerDashboardPage]
class TrackerDashboardRoute extends PageRouteInfo<void> {
  const TrackerDashboardRoute({List<PageRouteInfo>? children})
      : super(
          TrackerDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackerDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrackerPublicationsPage]
class TrackerPublicationsRoute extends PageRouteInfo<void> {
  const TrackerPublicationsRoute({List<PageRouteInfo>? children})
      : super(
          TrackerPublicationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackerPublicationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrackerSubscriptionPage]
class TrackerSubscriptionRoute extends PageRouteInfo<void> {
  const TrackerSubscriptionRoute({List<PageRouteInfo>? children})
      : super(
          TrackerSubscriptionRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackerSubscriptionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrackerSystemPage]
class TrackerSystemRoute extends PageRouteInfo<void> {
  const TrackerSystemRoute({List<PageRouteInfo>? children})
      : super(
          TrackerSystemRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackerSystemRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserBookmarkListPage]
class UserBookmarkListRoute extends PageRouteInfo<UserBookmarkListRouteArgs> {
  UserBookmarkListRoute({
    Key? key,
    String type = '',
    List<PageRouteInfo>? children,
  }) : super(
          UserBookmarkListRoute.name,
          args: UserBookmarkListRouteArgs(
            key: key,
            type: type,
          ),
          rawPathParams: {'type': type},
          initialChildren: children,
        );

  static const String name = 'UserBookmarkListRoute';

  static const PageInfo<UserBookmarkListRouteArgs> page =
      PageInfo<UserBookmarkListRouteArgs>(name);
}

class UserBookmarkListRouteArgs {
  const UserBookmarkListRouteArgs({
    this.key,
    this.type = '',
  });

  final Key? key;

  final String type;

  @override
  String toString() {
    return 'UserBookmarkListRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [UserCommentListPage]
class UserCommentListRoute extends PageRouteInfo<UserCommentListRouteArgs> {
  UserCommentListRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserCommentListRoute.name,
          args: UserCommentListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'UserCommentListRoute';

  static const PageInfo<UserCommentListRouteArgs> page =
      PageInfo<UserCommentListRouteArgs>(name);
}

class UserCommentListRouteArgs {
  const UserCommentListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'UserCommentListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [UserDashboardPage]
class UserDashboardRoute extends PageRouteInfo<UserDashboardRouteArgs> {
  UserDashboardRoute({
    Key? key,
    required String alias,
    List<PageRouteInfo>? children,
  }) : super(
          UserDashboardRoute.name,
          args: UserDashboardRouteArgs(
            key: key,
            alias: alias,
          ),
          rawPathParams: {'alias': alias},
          initialChildren: children,
        );

  static const String name = 'UserDashboardRoute';

  static const PageInfo<UserDashboardRouteArgs> page =
      PageInfo<UserDashboardRouteArgs>(name);
}

class UserDashboardRouteArgs {
  const UserDashboardRouteArgs({
    this.key,
    required this.alias,
  });

  final Key? key;

  final String alias;

  @override
  String toString() {
    return 'UserDashboardRouteArgs{key: $key, alias: $alias}';
  }
}

/// generated route for
/// [UserDetailPage]
class UserDetailRoute extends PageRouteInfo<UserDetailRouteArgs> {
  UserDetailRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserDetailRoute.name,
          args: UserDetailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'UserDetailRoute';

  static const PageInfo<UserDetailRouteArgs> page =
      PageInfo<UserDetailRouteArgs>(name);
}

class UserDetailRouteArgs {
  const UserDetailRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'UserDetailRouteArgs{key: $key}';
  }
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
class UserPublicationListRoute
    extends PageRouteInfo<UserPublicationListRouteArgs> {
  UserPublicationListRoute({
    Key? key,
    String type = '',
    List<PageRouteInfo>? children,
  }) : super(
          UserPublicationListRoute.name,
          args: UserPublicationListRouteArgs(
            key: key,
            type: type,
          ),
          rawPathParams: {'type': type},
          initialChildren: children,
        );

  static const String name = 'UserPublicationListRoute';

  static const PageInfo<UserPublicationListRouteArgs> page =
      PageInfo<UserPublicationListRouteArgs>(name);
}

class UserPublicationListRouteArgs {
  const UserPublicationListRouteArgs({
    this.key,
    this.type = '',
  });

  final Key? key;

  final String type;

  @override
  String toString() {
    return 'UserPublicationListRouteArgs{key: $key, type: $type}';
  }
}
