// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';

@RoutePage(name: PublicationFlow.routeName)
class PublicationFlow extends AutoRouter {
  static const String routePath = '/publication/:type/:id';
  static const String routeName = 'PublicationRouter';
}
