// ignore_for_file:use_key_in_widget_constructors
import 'package:auto_route/auto_route.dart';

@RoutePage(name: ArticlesRouterData.routeName)
class ArticlesRouterData extends AutoRouter {
  static const String routePath = 'articles';
  static const String routeName = 'ArticlesRouter';
}

///////////
@RoutePage(name: PostsRouterData.routeName)
class PostsRouterData extends AutoRouter {
  static const String routePath = 'posts';
  static const String routeName = 'PostsRouter';
}

///////////
@RoutePage(name: NewsRouterData.routeName)
class NewsRouterData extends AutoRouter {
  static const String routePath = 'news';
  static const String routeName = 'NewsRouter';
}

///////////
@RoutePage(name: ServicesRouterData.routeName)
class ServicesRouterData extends AutoRouter {
  static const String routePath = 'services';
  static const String routeName = 'ServicesRouter';
}
