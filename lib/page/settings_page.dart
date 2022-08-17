import 'package:auto_route/auto_route.dart';
import 'package:flabr/components/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsRoute extends PageRouteInfo {
  const SettingsRoute() : super(name, path: '/settings/');

  static const String name = 'SettingsRoute';
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SettingsView()),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BlocBuilder<ThemeCubit, bool>(
          builder: (context, state) {
            return SwitchListTile.adaptive(
              title: const Text('Темная тема'),
              value: state,
              onChanged: (val) {
                context.read<ThemeCubit>().toggle(value: val);
              },
            );
          },
        ),
      ],
    );
  }
}
