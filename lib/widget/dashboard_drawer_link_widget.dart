import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardDrawerLinkWidget extends StatelessWidget {
  const DashboardDrawerLinkWidget({
    Key? key,
    required this.title,
    required this.route,
  }) : super(key: key);

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final tabRouter = context.router;

    return ListTile(
      title: Text(title),
      onTap: () {
        tabRouter.navigateNamed(route);

        /// закрываем Drawer из DashboardPage
        Navigator.of(context).pop();
      },
    );
  }
}
