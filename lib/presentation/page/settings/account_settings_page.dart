import 'package:flutter/material.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../core/constants/constants.dart';
import '../../extension/extension.dart';
import '../../widget/auth/auth.dart';
import '../../widget/profile/profile.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNestedScaffold(
      title: 'Аккаунт',
      children: [
        const SettingsSectionWidget(
          title: 'Профиль',
          children: [
            AccountTile(),
          ],
        ),
        SettingsSectionWidget(
          title: 'Интеграции',
          children: [
            const SettingsCardWidget(
              title: Keys.sidToken,
              subtitle: 'Если не удается войти через форму логина',
              child: Padding(
                padding: .only(top: 12.0),
                child: ConnectSidWidget(),
              ),
            ),
            SettingsCardWidget(
              title: 'YandexGPT',
              subtitle: 'Для генерации пересказов статей',
              child: Padding(
                padding: const .only(top: 12.0),
                child: SummaryTokenWidget(
                  onShowSnack: (text) {
                    context.showSnack(content: Text(text));
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
