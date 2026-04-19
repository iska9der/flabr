import 'package:flutter/material.dart';

import '../../../../../core/component/router/router.dart';
import '../../../../../data/model/hub/hub.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class HubCardWidget extends StatelessWidget {
  const HubCardWidget({
    super.key,
    required this.model,
    this.renderType = .plain,
  });

  final Hub model;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    var stats = model.statistics as HubStatistics;

    final theme = context.theme;
    final tagStyle = theme.textTheme.bodySmall!.copyWith(
      color: theme.colors.textSecondary,
    );

    return FlabrCard(
      onTap: () => getIt<AppRouter>().navigate(
        HubDashboardRoute(alias: model.alias),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              CardAvatarWidget(
                imageUrl: model.imageUrl,
                placeholderIcon: AppIcons.hubPlaceholder,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    CardTitleWidget(
                      title: model.titleHtml,
                      renderType: renderType,
                    ),
                    if (model.descriptionHtml.isNotEmpty)
                      Text(
                        model.descriptionHtml,
                        style: theme.textTheme.labelMedium,
                      ),
                    if (model.commonTags.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        children: model.commonTags
                            .map(
                              (tag) => Text(tag, style: tagStyle),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: .center,
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
        ],
      ),
    );
  }
}
