import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class NewsRoute extends PageRouteInfo {
  const NewsRoute() : super(name, path: '/news/');

  static const String name = 'NewsRoute';
}

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('News'),
      ),
    );
  }
}
