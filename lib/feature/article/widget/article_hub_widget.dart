import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/hub_type.dart';
import '../../hub/model/hub_related_data.dart';
import '../model/article_hub_model.dart';

class ArticleHubsWidget extends StatelessWidget {
  const ArticleHubsWidget({Key? key, required this.hubs}) : super(key: key);

  final List<ArticleHubModel> hubs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: hubs.map((hub) => _ArticleHubWidget(hub)).toList(),
    );
  }
}

/// todo: когда появится авторизация, в `hub.relatedData`
/// будет свойство `isSubscribed` - при true, добавлять
/// в билд методе к стилю зеленый цвет
///
/// ``` style = style.copyWith(color: Colors.green) ```
///
///
/// так же у `ArticleHubModel` есть свойство `type`
/// который может быть коллективным(хаб), или корпоративным (блог компании)
///
/// в зависимости от типа, ссылка перехода в методе `onTap` будет меняться
///
class _ArticleHubWidget extends StatelessWidget {
  const _ArticleHubWidget(this.hub, {Key? key}) : super(key: key);

  final ArticleHubModel hub;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodySmall;

    if ((hub.relatedData as HubRelatedData).isSubscribed) {
      style = style?.copyWith(color: Colors.green);
    }

    var title = hub.title;
    if (hub.isProfiled) {
      title += '*';
    }

    var path = hub.type.isCorporative ? 'companies' : 'hubs';

    return InkWell(
      onTap: () => context.navigateNamedTo('services/$path/${hub.alias}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Text(
          title,
          style: style,
          softWrap: true,
        ),
      ),
    );
  }
}
