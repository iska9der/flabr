import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../data/model/filter/filter.dart';
import '../../../i18n/i18n.dart';
import '../../widget/filter/filter_chip_list.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

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
      title: context.t.feed.settingsTitle,
      children: [
        SettingsSectionWidget(
          title: context.t.feed.cardsSection,
          children: [
            const SettingsFeedWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: context.t.feed.behaviorSection,
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
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isImageVisible,
            title: Text(context.t.feed.images.label),
            subtitle: Text(context.t.feed.images.performanceNote),
            onChanged: (bool value) =>
                settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isDescriptionVisible,
            title: Text(context.t.feed.shortDescription),
            onChanged: (bool value) =>
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
      title: context.t.feed.navigation,
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.feed.navigationMode != current.feed.navigationMode,
            builder: (context, state) {
              return FilterChipList(
                options: FeedNavigationMode.values
                    .map(
                      (mode) => FilterOption(
                        label: mode.label,
                        value: mode.name,
                      ),
                    )
                    .toList(),
                isSelected: (option) =>
                    state.feed.navigationMode.name == option.value,
                onSelected: (_, option) {
                  final mode = FeedNavigationMode.values.byName(option.value);
                  context.read<SettingsCubit>().changeFeedNavigationMode(mode);
                },
              );
            },
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationAlignment !=
                current.misc.navigationAlignment,
            builder: (context, state) {
              return Padding(
                padding: const .only(top: 8.0),
                child: FilterChipList(
                  options: NavigationAlignment.values
                      .map((e) => FilterOption(label: e.label, value: e.label))
                      .toList(),
                  isSelected: (option) =>
                      state.misc.navigationAlignment.label == option.label,
                  onSelected: (isSelected, option) {
                    final resolved = NavigationAlignment.values.firstWhere(
                      (element) => element.label == option.value,
                    );

                    context.read<SettingsCubit>().changeNavigationAlignment(
                      resolved,
                    );
                  },
                ),
              );
            },
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationOnScrollVisible !=
                current.misc.navigationOnScrollVisible,
            builder: (context, state) {
              return SettingsCheckboxWidget(
                initialValue: state.misc.navigationOnScrollVisible,
                title: Text(context.t.feed.showOnScroll),
                onChanged: (bool value) => context
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
