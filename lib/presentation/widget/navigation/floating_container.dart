import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../page/settings/model/config_model.dart';
import '../../theme/theme.dart';

class FloatingContainer extends StatelessWidget {
  const FloatingContainer({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final navAlign = context.select<SettingsCubit, NavigationAlignment>(
      (cubit) => cubit.state.misc.navigationAlignment,
    );

    final double padding = switch (navAlign) {
      NavigationAlignment.start => 0,
      NavigationAlignment.center => AppDimensions.navBarHeight + 16,
      NavigationAlignment.end => AppDimensions.navBarHeight + 16,
    };

    return Padding(
      padding: .only(bottom: padding),
      child: Column(
        mainAxisAlignment: .end,
        children: children,
      ),
    );
  }
}
