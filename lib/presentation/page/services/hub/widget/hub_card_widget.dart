import 'package:flutter/material.dart';

import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/hub/hub.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class HubCardWidget extends StatelessWidget {
  const HubCardWidget({
    super.key,
    required this.model,
    this.renderType = RenderType.plain,
  });

  final Hub model;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    var stats = model.statistics as HubStatistics;
    final tagStyle = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlabrCard(
          onTap:
              () => getIt<AppRouter>().navigate(
                HubDashboardRoute(alias: model.alias),
              ),
          child: Row(
            children: [
              CardAvatarWidget(
                imageUrl: model.imageUrl,
                placeholderIcon: AppIcons.hubPlaceholder,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardTitleWidget(
                      title: model.titleHtml,
                      renderType: renderType,
                    ),
                    Text(
                      model.descriptionHtml,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children:
                          model.commonTags
                              .map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    4,
                                    16,
                                    4,
                                  ),
                                  child: Text(tag, style: tagStyle),
                                ),
                              )
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
        ),
      ],
    );
  }
}
