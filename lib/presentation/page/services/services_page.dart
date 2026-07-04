import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../extension/extension.dart';
import '../../widget/enhancement/card.dart';
import 'company/company_list_page.dart';
import 'hub/hub_list_page.dart';
import 'user/user_list_page.dart';

@RoutePage(name: ServicesPage.routeName)
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const routeName = 'ServicesRoute';
  static const routePath = '';

  @override
  Widget build(BuildContext context) {
    return const ServicesPageView();
  }
}

class ServicesPageView extends StatelessWidget {
  const ServicesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            ServiceCard(
              title: HubListPage.name,
              icon: Icons.hub_rounded,
              onTap: () => context.router.pushWidget(const HubListPage()),
            ),
            ServiceCard(
              title: UserListPage.name,
              icon: Icons.supervisor_account_sharp,
              onTap: () => context.router.pushWidget(const UserListPage()),
            ),
            ServiceCard(
              title: CompanyListPage.name,
              icon: Icons.cases_rounded,
              onTap: () => context.router.pushWidget(const CompanyListPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isEnabled = onTap != null;

    return FlabrCard(
      elevation: isEnabled ? 6 : 0,
      color: onTap != null ? context.cardTheme.color : theme.disabledColor,
      onTap: onTap,
      child: Stack(
        fit: .expand,
        children: [
          Icon(
            icon,
            size: 60,
            color: isEnabled
                ? theme.colors.primary
                : theme.colors.primary.withValues(alpha: .4),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              title,
              textAlign: .center,
              maxLines: 1,
              style: theme.textTheme.titleSmall!.copyWith(
                color: isEnabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.inverseSurface.withValues(
                        alpha: .4,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
