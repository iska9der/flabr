import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../i18n/i18n.dart';
import '../../extension/extension.dart';
import '../../page/settings/model/config_model.dart';
import '../../theme/theme.dart';
import 'cubit/navigation_cubit.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.router,
  });

  final TabsRouter router;

  static FloatingActionButtonLocation getLocation({
    NavigationAlignment alignment = .start,
  }) => switch (alignment) {
    NavigationAlignment.start => .miniStartFloat,
    NavigationAlignment.center => .miniCenterFloat,
    NavigationAlignment.end => .miniEndFloat,
  };

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      hiddenConditions: const [
        .largerThan(name: ScreenType.mobile, value: false),
      ],
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return AnimatedContainer(
            duration: AppDuration.hide,
            height: state.isNavigationVisible ? AppDimensions.navBarHeight : 0,
            width: Device.getWidth(context) * .75,
            clipBehavior: .hardEdge,
            color: Colors.transparent,
            child: _BottomNavigation(router: router),
          );
        },
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.router});

  final TabsRouter router;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: .hardEdge,
      borderRadius: .circular(100),
      child: NavigationBar(
        labelBehavior: .alwaysShow,
        selectedIndex: router.activeIndex,
        // backgroundColor: Colors.transparent,
        // surfaceTintColor: Colors.transparent,
        // overlayColor: .all(Colors.transparent),
        // shadowColor: Colors.transparent,
        elevation: 0,
        labelPadding: .zero,
        labelTextStyle: .all(context.theme.textTheme.labelSmall!),
        onDestinationSelected: (i) {
          /// при нажатию на таб, в котором
          /// мы уже находимся - выходим в корень
          if (router.activeIndex == i) {
            var rootOfIndex = router.stackRouterOfIndex(i);
            rootOfIndex?.popUntilRoot();
          } else {
            router.setActiveIndex(i);
          }
        },
        destinations: [
          NavigationDestination(
            label: context.t.navigation.publications,
            icon: const Icon(Icons.article_rounded),
          ),
          NavigationDestination(
            label: context.t.navigation.services,
            icon: const Icon(Icons.widgets_rounded),
          ),
          NavigationDestination(
            label: context.t.navigation.settings,
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}
