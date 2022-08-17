import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends PageRouteInfo {
  const SettingsRoute() : super(name, path: '/settings/');

  static const String name = 'SettingsRoute';
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}
