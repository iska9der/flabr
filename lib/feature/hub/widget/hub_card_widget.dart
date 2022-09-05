import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../common/model/render_type.dart';
import '../../../common/model/stat_type.dart';
import '../../../config/constants.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/profile_stat_card_widget.dart';
import '../../user/widget/user_avatar_widget.dart';
import '../model/hub_model.dart';
import '../model/hub_statistics_model.dart';

class HubCardWidget extends StatelessWidget {
  const HubCardWidget({
    Key? key,
    required this.model,
    this.renderType = RenderType.plain,
  }) : super(key: key);

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
              UserAvatarWidget(imageUrl: model.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HubTitleWidget(
                      title: model.titleHtml,
                      renderType: renderType,
                      onPressed: () => context.router.navigateNamed(
                        'services/hubs/${model.alias}/profile',
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
                value: stats.rating,
              ),
              ProfileStatCardWidget(
                title: 'Подписчики',
                value: stats.subscribersCount,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _HubTitleWidget extends StatelessWidget {
  const _HubTitleWidget({
    Key? key,
    required this.title,
    required this.renderType,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final RenderType renderType;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kBorderRadiusDefault),
      onTap: onPressed,
      child: renderType == RenderType.plain
          ? Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            )
          : HtmlWidget(
              title,
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.headline6?.color,
                fontSize: Theme.of(context).textTheme.headline6?.fontSize,
              ),
            ),
    );
  }
}
