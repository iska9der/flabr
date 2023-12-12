import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/hub_type.dart';
import '../../hub/model/hub_related_data.dart';
import '../../publication/model/publication_hub_model.dart';

class ArticleHubsWidget extends StatelessWidget {
  const ArticleHubsWidget({super.key, required this.hubs});

  final List<PublicationHubModel> hubs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      children: hubs.map((hub) => _ArticleHubWidget(hub)).toList(),
    );
  }
}

/// TODO: у `ArticleHubModel` есть свойство `type`
/// который может быть коллективным(хаб), или корпоративным (блог компании)
///
/// в зависимости от типа, ссылка перехода в методе `onTap` будет меняться
///
class _ArticleHubWidget extends StatelessWidget {
  const _ArticleHubWidget(this.hub);

  final PublicationHubModel hub;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodySmall;

    if ((hub.relatedData as HubRelatedData).isSubscribed) {
      style = style?.copyWith(color: Colors.green.shade300);
    }

    var title = hub.title;
    if (hub.isProfiled) {
      title += '*';
    }

    var path = hub.type.isCorporative ? 'companies' : 'hubs';

    return InkWell(
      onTap: () => context.navigateNamedTo('services/$path/${hub.alias}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: style,
          softWrap: true,
        ),
      ),
    );
  }
}
