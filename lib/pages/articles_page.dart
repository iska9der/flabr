import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ArticlesRoute extends PageRouteInfo {
  const ArticlesRoute() : super(name, path: '/articles/');

  static const String name = 'ArticlesRoute';
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Articles'),
      ),
    );
  }
}
