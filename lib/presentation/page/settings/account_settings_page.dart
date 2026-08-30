import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../feature/summary/summary.dart';
import '../../../i18n/i18n.dart';
import '../../widget/auth/auth.dart';
import '../../widget/profile/profile.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  static const String routePath = 'account';

  @override
  Widget build(BuildContext context) {
    return const AccountSettingsView();
  }
}

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNestedScaffold(
      title: context.t.settings.account,
      children: [
        SettingsSectionWidget(
          title: context.t.account.profile,
          children: [
            const AccountTile(),
          ],
        ),
        SettingsSectionWidget(
          title: context.t.settings.integrations,
          children: [
            SettingsCardWidget(
              title: Keys.sidToken,
              subtitle: context.t.auth.loginFallbackHint,
              child: const Padding(
                padding: .only(top: 12.0),
                child: ConnectSidWidget(),
              ),
            ),
            SettingsCardWidget(
              title: 'YandexGPT',
              subtitle: context.t.summary.generationPurpose,
              child: const Padding(
                padding: .only(top: 12.0),
                child: SummaryTokenWidget(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
