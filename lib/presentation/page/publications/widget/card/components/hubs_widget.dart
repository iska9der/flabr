import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/component/router/app_router.dart';
import '../../../../../../data/model/hub/hub.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../di/di.dart';
import '../../../../../extension/context.dart';
import '../../../../../theme/theme.dart';

class PublicationHubsWidget extends StatelessWidget {
  const PublicationHubsWidget({super.key, required this.hubs});

  final List<PublicationHub> hubs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 6,
      children: hubs.map((hub) => _PublicationHub(hub: hub)).toList(),
    );
  }
}

/// у `PublicationHubModel` есть свойство `type`
/// который может быть коллективным (хаб), или корпоративным (блог компании).
/// в зависимости от типа, ссылка перехода в методе `onTap` будет меняться
class _PublicationHub extends StatelessWidget {
  // ignore: unused_element_parameter
  const _PublicationHub({super.key, required this.hub});

  final PublicationHub hub;

  @override
  Widget build(BuildContext context) {
    var style = context.theme.textTheme.labelMedium;

    if ((hub.relatedData as HubRelatedData).isSubscribed) {
      style = style?.copyWith(color: Colors.green.shade300);
    }

    var title = hub.title;
    if (hub.isProfiled) {
      title += '*';
    }

    final route =
        switch (hub.type.isCorporative) {
              true => CompanyDashboardRoute(alias: hub.alias),
              false => HubDashboardRoute(alias: hub.alias),
            }
            as PageRouteInfo;

    return InkWell(
      onTap: () => getIt<AppRouter>().navigate(route),
      borderRadius: AppStyles.borderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Text(title, style: style, softWrap: true),
      ),
    );
  }
}
