import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../data/model/hub/hub.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class HubProfileCardWidget extends StatefulWidget {
  const HubProfileCardWidget({super.key, required this.profile});

  final HubProfile profile;

  @override
  State<HubProfileCardWidget> createState() => _HubProfileCardWidgetState();
}

class _HubProfileCardWidgetState extends State<HubProfileCardWidget> {
  @override
  void initState() {
    /// Регистрируем репозиторий подписки для [SubscribeButton]
    getIt.allowReassignment = true;
    getIt.registerFactory<SubscriptionRepository>(
      () => HubSubscriptionRepository(getIt()),
    );

    super.initState();
  }

  @override
  void dispose() {
    bool isReg = getIt.isRegistered<SubscriptionRepository>();

    if (isReg) {
      getIt.unregister<SubscriptionRepository>();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final translation = context.t;

    final profile = widget.profile;
    final stats = profile.statistics;

    return FlabrCard(
      padding: AppInsets.md,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              CardAvatarWidget(
                imageUrl: profile.imageUrl,
                placeholderIcon: AppIcons.hubPlaceholder,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 2,
                  children: [
                    Text(
                      profile.titleHtml,
                      textAlign: .left,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.descriptionHtml,
                      maxLines: 3,
                      overflow: .ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 6,
            children: [
              if (stats.reach case final reach? when reach.isNotEmpty)
                Expanded(
                  child: ProfileStatCardWidget(
                    title: translation.common.reach,
                    value: reach,
                    valueColor: theme.colors.accentPrimary,
                  ),
                ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: translation.hub.rating,
                  value: stats.rating.toString(),
                  valueColor: StatType.rating.getColorByScore(
                    stats.rating,
                    theme.colors,
                  ),
                ),
              ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: translation.hub.followerCount,
                  value: stats.subscribersCount.compact(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HtmlWidget(profile.fullDescriptionHtml),
          const SizedBox(height: 12),
          SubscribeButton(
            alias: profile.alias,
            isSubscribed: (profile.relatedData as HubRelatedData).isSubscribed,
          ),
        ],
      ),
    );
  }
}
