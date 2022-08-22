import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../component/router/router.gr.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  static const routeName = 'AllServicesRoute';
  static const routePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          children: [
            ListTile(
              title: const Text('Хабы'),
              subtitle: const Text('недоступно'),
              tileColor: Theme.of(context).disabledColor,
              onTap: null,
            ),
            ListTile(
              title: const Text('Авторы'),
              tileColor: Colors.red,
              onTap: () {
                context.router.push(const UserListRoute());
              },
            ),
            ListTile(
              title: const Text('Компании'),
              subtitle: const Text('недоступно'),
              tileColor: Theme.of(context).disabledColor,
              onTap: null,
            )
          ],
        ),
      ),
    );
  }
}
