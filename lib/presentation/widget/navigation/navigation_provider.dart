import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import 'cubit/navigation_cubit.dart';

class NavigationProvider extends StatefulWidget {
  const NavigationProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<NavigationProvider> createState() => _NavigationProviderState();
}

class _NavigationProviderState extends State<NavigationProvider> {
  late NavigationCubit cubit = NavigationCubit();

  late bool isHidingDisabled = context
      .read<SettingsCubit>()
      .state
      .misc
      .navigationOnScrollVisible;

  @override
  void dispose() {
    cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.misc.navigationOnScrollVisible !=
          current.misc.navigationOnScrollVisible,
      listener: (context, state) {
        isHidingDisabled = state.misc.navigationOnScrollVisible;

        if (isHidingDisabled) {
          /// Слушаем изменение настройки видимости панели навигации
          /// для сброса высоты навигации, когда пользователь делает
          /// ее видимой всегда
          cubit.show();
        }
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (isHidingDisabled) {
            return false;
          }

          final axis = notification.metrics.axisDirection;
          if (axis == .right || axis == .left) {
            return false;
          }

          /// Слушаем уведомления о скролле, чтобы скрыть навигацию,
          /// когда пользователь скроллит вниз
          switch (notification.direction) {
            case .forward:
              cubit.show();
            case .reverse:
              cubit.hide();
            default:
          }

          return false;
        },
        child: BlocProvider.value(
          value: cubit,
          child: widget.child,
        ),
      ),
    );
  }
}
