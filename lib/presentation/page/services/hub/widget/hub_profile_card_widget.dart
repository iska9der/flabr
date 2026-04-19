import 'package:flutter/material.dart';

import '../../../../../data/model/hub/hub.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_detail_widget.dart';

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

    var profile = widget.profile;
    var stats = profile.statistics;

    return FlabrCard(
      padding: AppInsets.profileCardPadding,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              CardAvatarWidget(
                imageUrl: profile.imageUrl,
                placeholderIcon: AppIcons.hubPlaceholder,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    ProfileStatDetailWidget(
                      type: StatType.rating,
                      title: 'Рейтинг',
                      value: stats.rating,
                    ),
                    ProfileStatDetailWidget(
                      title: 'Подписчиков',
                      value: stats.subscribersCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.titleHtml,
            textAlign: .left,
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            profile.descriptionHtml,
            textAlign: .left,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Text(
            profile.fullDescriptionHtml,
            textAlign: .left,
          ),
          const SizedBox(height: 16),
          SubscribeButton(
            alias: profile.alias,
            isSubscribed: (profile.relatedData as HubRelatedData).isSubscribed,
          ),
        ],
      ),
    );
  }
}
