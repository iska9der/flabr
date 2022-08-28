import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
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
    var title = hub.title;
    var style = Theme.of(context).textTheme.caption;

    if (hub.isProfiled) {
      title += '*';
    }

    return InkWell(
      onTap: () => getIt.get<Utils>().showNotification(
            context: context,
            content: Text('Тут будет переход в ${hub.alias}'),
          ),
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
