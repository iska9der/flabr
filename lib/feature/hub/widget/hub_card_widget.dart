import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/extension/num_x.dart';
import '../../../common/model/stat_type.dart';
import '../../../component/router/app_router.dart';
import '../../../config/constants.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/profile_stat_card_widget.dart';
import '../../user/widget/user_avatar_widget.dart';
import '../model/hub_model.dart';
import '../model/hub_statistics_model.dart';

class HubCardWidget extends StatelessWidget {
  const HubCardWidget({Key? key, required this.model}) : super(key: key);

  final HubModel model;

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
              UserAvatarWidget(imageUrl: model.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(kBorderRadiusDefault),
                      onTap: () => context.router.push(
                        HubDashboardRoute(
                          alias: model.alias,
                          children: const [HubDetailRoute()],
                        ),
                      ),
                      child: Text(
                        model.titleHtml,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Text(
                      model.descriptionHtml,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: model.commonTags
                          .map((tag) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  tag,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ))
                          .toList(),
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
              ProfileStatCardWidget(
                type: StatType.rating,
                title: 'Рейтинг',
                text: stats.rating.toString(),
              ),
              ProfileStatCardWidget(
                title: 'Подписчики',
                text: stats.subscribersCount.compact(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
