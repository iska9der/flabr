import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardDrawerLinkWidget extends StatelessWidget {
  const DashboardDrawerLinkWidget({
    super.key,
    required this.title,
    required this.route,
  });

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final tabRouter = AutoRouter.of(context);

    return GestureDetector(
      /// TODO: Кабутабы ненужно. Без [GestureDetector] табы тоже переключаются
      onTap: () => tabRouter.navigateNamed(route),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(title),
      ),
    );
  }
}
