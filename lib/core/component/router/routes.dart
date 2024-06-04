// ignore_for_file:use_key_in_widget_constructors
import 'package:auto_route/auto_route.dart';

@RoutePage(name: ArticlesFlow.routeName)
class ArticlesFlow extends AutoRouter {
  static const String routePath = 'articles';
  static const String routeName = 'ArticlesRouter';
}

///////////
@RoutePage(name: PostsFlow.routeName)
class PostsFlow extends AutoRouter {
  static const String routePath = 'posts';
  static const String routeName = 'PostsRouter';
}

///////////
@RoutePage(name: NewsFlow.routeName)
class NewsFlow extends AutoRouter {
  static const String routePath = 'news';
  static const String routeName = 'NewsRouter';
}

///////////
@RoutePage(name: ServicesFlow.routeName)
class ServicesFlow extends AutoRouter {
  static const String routePath = 'services';
  static const String routeName = 'ServicesRouter';
}
