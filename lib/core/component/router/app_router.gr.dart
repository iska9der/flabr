// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ArticleListRouteArgs>(
          orElse: () =>
              ArticleListRouteArgs(flow: pathParams.getString('flow')));
      return ArticleListPage(
        key: args.key,
        flow: args.flow,
      );
    },
  );
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
/// [ArticlesFlowPage]
class ArticlesFlowRoute extends PageRouteInfo<void> {
  const ArticlesFlowRoute({List<PageRouteInfo>? children})
      : super(
          ArticlesFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'ArticlesFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ArticlesFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CompanyDashboardRouteArgs>(
          orElse: () =>
              CompanyDashboardRouteArgs(alias: pathParams.getString('alias')));
      return CompanyDashboardPage(
        key: args.key,
        alias: args.alias,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CompanyDetailRouteArgs>(
          orElse: () => CompanyDetailRouteArgs());
      return CompanyDetailPage(
        key: args.key,
        alias: pathParams.getString('alias'),
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompanyListPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
}

/// generated route for
/// [FeedFlowPage]
class FeedFlowRoute extends PageRouteInfo<void> {
  const FeedFlowRoute({List<PageRouteInfo>? children})
      : super(
          FeedFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedListPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<HubDashboardRouteArgs>(
          orElse: () =>
              HubDashboardRouteArgs(alias: pathParams.getString('alias')));
      return HubDashboardPage(
        key: args.key,
        alias: args.alias,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args =
          data.argsAs<HubDetailRouteArgs>(orElse: () => HubDetailRouteArgs());
      return HubDetailPage(
        key: args.key,
        alias: pathParams.getString('alias'),
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HubListPage();
    },
  );
}

/// generated route for
/// [NewsFlowPage]
class NewsFlowRoute extends PageRouteInfo<void> {
  const NewsFlowRoute({List<PageRouteInfo>? children})
      : super(
          NewsFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewsFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewsFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<NewsListRouteArgs>(
          orElse: () => NewsListRouteArgs(flow: pathParams.getString('flow')));
      return NewsListPage(
        key: args.key,
        flow: args.flow,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PostListRouteArgs>(
          orElse: () => PostListRouteArgs(flow: pathParams.getString('flow')));
      return PostListPage(
        key: args.key,
        flow: args.flow,
      );
    },
  );
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
/// [PostsFlowPage]
class PostsFlowRoute extends PageRouteInfo<void> {
  const PostsFlowRoute({List<PageRouteInfo>? children})
      : super(
          PostsFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostsFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostsFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PublicationCommentRouteArgs>(
          orElse: () => PublicationCommentRouteArgs());
      return PublicationCommentPage(
        key: args.key,
        type: pathParams.getString('type'),
        id: pathParams.getString('id'),
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PublicationDashboardPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PublicationDetailRouteArgs>(
          orElse: () => PublicationDetailRouteArgs());
      return PublicationDetailPage(
        key: args.key,
        type: pathParams.getString('type'),
        id: pathParams.getString('id'),
      );
    },
  );
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
/// [PublicationFlowPage]
class PublicationFlowRoute extends PageRouteInfo<PublicationFlowRouteArgs> {
  PublicationFlowRoute({
    Key? key,
    required String type,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PublicationFlowRoute.name,
          args: PublicationFlowRouteArgs(
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

  static const String name = 'PublicationFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PublicationFlowRouteArgs>(
          orElse: () => PublicationFlowRouteArgs(
                type: pathParams.getString('type'),
                id: pathParams.getString('id'),
              ));
      return PublicationFlowPage(
        key: args.key,
        type: args.type,
        id: args.id,
      );
    },
  );
}

class PublicationFlowRouteArgs {
  const PublicationFlowRouteArgs({
    this.key,
    required this.type,
    required this.id,
  });

  final Key? key;

  final String type;

  final String id;

  @override
  String toString() {
    return 'PublicationFlowRouteArgs{key: $key, type: $type, id: $id}';
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchAnywherePage();
    },
  );
}

/// generated route for
/// [ServicesFlowPage]
class ServicesFlowRoute extends PageRouteInfo<void> {
  const ServicesFlowRoute({List<PageRouteInfo>? children})
      : super(
          ServicesFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServicesFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServicesFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServicesPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackerDashboardPage();
    },
  );
}

/// generated route for
/// [TrackerFlowPage]
class TrackerFlowRoute extends PageRouteInfo<void> {
  const TrackerFlowRoute({List<PageRouteInfo>? children})
      : super(
          TrackerFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrackerFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackerFlowPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackerPublicationsPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackerSubscriptionPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackerSystemPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserBookmarkListRouteArgs>(
          orElse: () => UserBookmarkListRouteArgs(
                  type: pathParams.getString(
                'type',
                '',
              )));
      return UserBookmarkListPage(
        key: args.key,
        alias: pathParams.getString('alias'),
        type: args.type,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserCommentListRouteArgs>(
          orElse: () => UserCommentListRouteArgs());
      return UserCommentListPage(
        key: args.key,
        alias: pathParams.getString('alias'),
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserDashboardRouteArgs>(
          orElse: () =>
              UserDashboardRouteArgs(alias: pathParams.getString('alias')));
      return UserDashboardPage(
        key: args.key,
        alias: args.alias,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args =
          data.argsAs<UserDetailRouteArgs>(orElse: () => UserDetailRouteArgs());
      return UserDetailPage(
        key: args.key,
        alias: pathParams.getString('alias'),
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserListPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserPublicationListRouteArgs>(
          orElse: () => UserPublicationListRouteArgs(
                  type: pathParams.getString(
                'type',
                '',
              )));
      return UserPublicationListPage(
        key: args.key,
        alias: pathParams.getString('alias'),
        type: args.type,
      );
    },
  );
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
