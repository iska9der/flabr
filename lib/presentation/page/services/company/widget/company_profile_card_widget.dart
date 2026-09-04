import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../data/model/company/company.dart';
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

class CompanyProfileCardWidget extends StatefulWidget {
  const CompanyProfileCardWidget({super.key, required this.card});

  final CompanyCard card;

  @override
  State<CompanyProfileCardWidget> createState() =>
      _CompanyProfileCardWidgetState();
}

class _CompanyProfileCardWidgetState extends State<CompanyProfileCardWidget> {
  @override
  void initState() {
    /// Регистрируем репозиторий подписки для [SubscribeButton]
    getIt.allowReassignment = true;
    getIt.registerFactory<SubscriptionRepository>(
      () => CompanySubscriptionRepository(getIt()),
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

    final card = widget.card;
    final stats = card.statistics;

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
                imageUrl: card.imageUrl,
                placeholderIcon: AppIcons.companyPlaceholder,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 2,
                  children: [
                    Text(
                      card.titleHtml,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    if (card.descriptionHtml.isNotEmpty)
                      HtmlWidget(
                        card.descriptionHtml,
                        textStyle: theme.textTheme.titleSmall,
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
                  title: translation.company.rating,
                  value: stats.rating.toString(),
                  valueColor: StatType.rating.getColorByScore(
                    stats.rating,
                    theme.colors,
                  ),
                ),
              ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: translation.company.followerCount,
                  value: stats.subscribersCount.compact(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SubscribeButton(
            alias: card.alias,
            isSubscribed: (card.relatedData as CompanyRelatedData).isSubscribed,
          ),
        ],
      ),
    );
  }
}
