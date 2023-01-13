import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../feature/hub/page/hub_list_page.dart';
import '../feature/user/page/user_list_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  static const routeName = 'ServicesRoute';
  static const routePath = '';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ServicesPageView(),
    );
  }
}

class ServicesPageView extends StatelessWidget {
  const ServicesPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            title: 'Компании',
            icon: Icons.cases_rounded,
            // onTap: () => context.router.pushWidget(const CompanyListPage()),
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: onTap != null ? 6 : 0,
      clipBehavior: Clip.hardEdge,
      color: onTap != null
          ? Theme.of(context).cardColor
          : Theme.of(context).disabledColor,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Icon(
              icon,
              size: 60,
              color: onTap != null
                  ? Colors.yellow.shade800.withOpacity(.8)
                  : Theme.of(context).iconTheme.color?.withOpacity(0.2),
            ),
            Positioned(
              top: 65,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusDefault),
                  color: onTap != null
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(.7)
                      : Theme.of(context)
                          .colorScheme
                          .onInverseSurface
                          .withOpacity(.4),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: onTap != null
                        ? Theme.of(context).colorScheme.onInverseSurface
                        : Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
