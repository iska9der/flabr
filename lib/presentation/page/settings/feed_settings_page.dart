import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../i18n/i18n.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';
import 'widget/settings_segmented_button.dart';

@RoutePage()
class FeedSettingsPage extends StatelessWidget {
  const FeedSettingsPage({super.key});

  static const String routePath = 'feed';

  @override
  Widget build(BuildContext context) {
    return const FeedSettingsView();
  }
}

class FeedSettingsView extends StatelessWidget {
  const FeedSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNestedScaffold(
      title: context.t.settings.feed.title,
      description: context.t.settings.feed.description,
      children: [
        SettingsSectionWidget(
          title: context.t.settings.feed.sections.cards,
          children: [
            const SettingsFeedWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: context.t.settings.feed.sections.behavior,
          children: [
            const SettingNavVisibilityWidget(),
          ],
        ),
      ],
    );
  }
}

class SettingsFeedWidget extends StatelessWidget {
  const SettingsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return SettingsCardWidget(
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isImageVisible,
            icon: Icons.image_outlined,
            title: Text(context.t.settings.feed.cards.images.label),
            subtitle: Text(
              context.t.settings.feed.cards.images.performanceNote,
            ),
            onChanged: (value) =>
                settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          const Divider(height: 1),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isDescriptionVisible,
            icon: Icons.notes_rounded,
            title: Text(context.t.settings.feed.cards.shortDescription),
            onChanged: (value) =>
                settingsCubit.changeFeedDescVisibility(isVisible: value),
          ),
        ],
      ),
    );
  }
}

class SettingNavVisibilityWidget extends StatelessWidget {
  const SettingNavVisibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      icon: Icons.alt_route_rounded,
      title: context.t.settings.feed.navigation.title,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.feed.navigationMode != current.feed.navigationMode,
            builder: (context, state) {
              return SettingsSegmentedButton<FeedNavigationMode>(
                segments: FeedNavigationMode.values
                    .map(
                      (mode) => ButtonSegment(
                        value: mode,
                        label: Text(mode.label),
                      ),
                    )
                    .toList(),
                value: state.feed.navigationMode,
                onChanged: context
                    .read<SettingsCubit>()
                    .changeFeedNavigationMode,
              );
            },
          ),
          const Divider(height: 1),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationAlignment !=
                current.misc.navigationAlignment,
            builder: (context, state) {
              return SettingsSegmentedButton<NavigationAlignment>(
                segments: NavigationAlignment.values
                    .map(
                      (alignment) => ButtonSegment(
                        value: alignment,
                        label: Text(alignment.label),
                      ),
                    )
                    .toList(),
                value: state.misc.navigationAlignment,
                onChanged: context
                    .read<SettingsCubit>()
                    .changeNavigationAlignment,
              );
            },
          ),
          const Divider(height: 1),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationOnScrollVisible !=
                current.misc.navigationOnScrollVisible,
            builder: (context, state) {
              return SettingsCheckboxWidget(
                initialValue: state.misc.navigationOnScrollVisible,
                icon: Icons.vertical_align_center_rounded,
                title: Text(context.t.settings.feed.navigation.showOnScroll),
                onChanged: (value) => context
                    .read<SettingsCubit>()
                    .changeNavigationOnScrollVisibility(isVisible: value),
              );
            },
          ),
        ],
      ),
    );
  }
}
