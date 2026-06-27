import 'package:flutter/material.dart';

import '../../widget/publication_settings_widget.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

class PublicationSettingsView extends StatelessWidget {
  const PublicationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsNestedScaffold(
      title: 'Публикации',
      children: [
        SettingsSectionWidget(
          title: 'Чтение',
          children: [
            SettingsCardWidget(child: PublicationSettingsWidget()),
          ],
        ),
      ],
    );
  }
}
