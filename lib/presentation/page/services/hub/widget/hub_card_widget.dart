import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../data/model/hub/hub_model.dart';
import '../../../../../data/model/hub/hub_statistics_model.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';
import '../../services_flow.dart';

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
                        '${ServicesFlow.routePath}/hubs/${model.alias}/profile',
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
