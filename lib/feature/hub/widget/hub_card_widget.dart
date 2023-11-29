import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/render_type.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/feed/card_title_widget.dart';
import '../../../common/widget/profile_stat_card_widget.dart';
import '../../../component/router/routes.dart';
import '../../../config/constants.dart';
import '../model/hub_model.dart';
import '../model/hub_statistics_model.dart';

class HubCardWidget extends StatelessWidget {
  const HubCardWidget({
    super.key,
    required this.model,
    this.renderType = RenderType.plain,
  });

  final HubModel model;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    var stats = model.statistics as HubStatisticsModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlabrCard(
          padding: const EdgeInsets.all(kCardPadding),
          child: Row(
            children: [
              CardAvatarWidget(imageUrl: model.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardTitleWidget(
                      title: model.titleHtml,
                      renderType: renderType,
                      onPressed: () => context.router.navigateNamed(
                        '${ServicesRouterData.routePath}/hubs/${model.alias}/profile',
                      ),
                    ),
                    Text(
                      model.descriptionHtml,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: model.commonTags.map((tag) {
                        final style = Theme.of(context).textTheme.bodySmall;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: Text(tag, style: style),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ProfileStatCardWidget(
                  type: StatType.rating,
                  title: 'Рейтинг',
                  value: stats.rating,
                ),
              ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: 'Подписчики',
                  value: stats.subscribersCount,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
