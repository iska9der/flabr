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

    return TextButton(
      style: Theme.of(context).textButtonTheme.style?.copyWith(
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      onPressed: () => tabRouter.navigateNamed(route),
      child: Text(title),
    );
  }
}
