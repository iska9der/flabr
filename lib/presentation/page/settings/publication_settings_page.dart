import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../i18n/i18n.dart';
import '../../widget/publication_settings_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class PublicationSettingsPage extends StatelessWidget {
  const PublicationSettingsPage({super.key});

  static const String routePath = 'publication';

  @override
  Widget build(BuildContext context) {
    return const PublicationSettingsView();
  }
}

class PublicationSettingsView extends StatelessWidget {
  const PublicationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNestedScaffold(
      title: context.t.publication.settingsTitle,
      children: [
        const SettingsSectionWidget(
          children: [
            PublicationSettingsWidget(),
          ],
        ),
      ],
    );
  }
}
