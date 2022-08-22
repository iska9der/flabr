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
          child: Column(
        children: [
          ListTile(
            title: const Text('Авторы'),
            tileColor: Colors.red,
            onTap: () {
              context.router.push(const UsersRoute());
            },
          )
        ],
      )),
    );
  }
}
