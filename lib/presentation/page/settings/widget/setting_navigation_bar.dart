import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';
import 'settings_card_widget.dart';

class SettingNavigationOnScroll extends StatelessWidget {
  const SettingNavigationOnScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Нижняя навигация',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.misc.navigationOnScrollVisible !=
            current.misc.navigationOnScrollVisible,
        builder: (context, state) {
          return SwitchListTile.adaptive(
            title: const Text('Показывать при прокрутке'),
            contentPadding: EdgeInsets.zero,
            value: state.misc.navigationOnScrollVisible,
            onChanged: (val) {
              context
                  .read<SettingsCubit>()
                  .changeNavigationOnScrollVisibility(isVisible: val);
            },
          );
        },
      ),
    );
  }
}
