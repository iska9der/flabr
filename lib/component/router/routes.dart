// ignore_for_file:use_key_in_widget_constructors
import 'package:auto_route/auto_route.dart';

@RoutePage(name: 'MyArticlesRoute')
class MyArticlesRouteEmpty extends AutoRouter {}

class MyArticlesRouteInfo {
  static const String routePath = 'articles';
  static const String routeName = 'ArticlesEmptyRoute';
}

@RoutePage(name: 'MyUsersRoute')
class MyUsersRouteEmpty extends AutoRouter {}

class MyUsersRouteInfo {
  static const String routePath = 'users';
  static const String routeName = 'UsersEmptyRoute';
}

@RoutePage(name: 'MyNewsRoute')
class MyNewsRouteEmpty extends AutoRouter {}

class MyNewsRouteInfo {
  static const String routePath = 'news';
  static const String routeName = 'NewsEmptyRoute';
}

@RoutePage(name: 'MyServicesRoute')
class MyServicesRouteEmpty extends AutoRouter {}

class MyServicesRouteInfo {
  static const String routePath = 'services';
  static const String routeName = 'ServicesEmptyRoute';
}
