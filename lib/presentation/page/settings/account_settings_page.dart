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
      title: context.t.settings.account.title,
      description: context.t.settings.account.description,
      children: [
        SettingsSectionWidget(
          title: context.t.settings.account.sections.profile,
          children: [
            const SettingsCardWidget(
              padding: .zero,
              child: AccountTile(),
            ),
          ],
        ),
        SettingsSectionWidget(
          title: context.t.settings.account.sections.integrations,
          children: [
            SettingsCardWidget(
              title: Keys.sidToken,
              icon: Icons.key_rounded,
              subtitle: context.t.auth.login.fallbackHint,
              child: const Padding(
                padding: .only(top: 12.0),
                child: ConnectSidWidget(),
              ),
            ),
            SettingsCardWidget(
              title: 'YandexGPT',
              icon: Icons.auto_awesome_rounded,
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
