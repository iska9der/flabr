import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/settings/cubit/settings_cubit.dart';

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
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SwitchListTile.adaptive(
              title: const Text('Темная тема'),
              value: state.isDarkTheme,
              onChanged: (val) {
                context.read<SettingsCubit>().changeTheme(isDarkTheme: val);
              },
            );
          },
        ),
      ],
    );
  }
}
