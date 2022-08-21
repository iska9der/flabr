import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/theme/cubit/theme_cubit.dart';

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
