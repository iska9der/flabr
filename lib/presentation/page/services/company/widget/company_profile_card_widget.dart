import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../data/model/company/company.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_widget.dart';

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
    var card = widget.card;
    var stats = card.statistics as CompanyCardStatistics;

    return FlabrCard(
      padding: AppInsets.profileCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CardAvatarWidget(
                imageUrl: card.imageUrl,
                placeholderIcon: AppIcons.companyPlaceholder,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileStatWidget(
                      type: StatType.rating,
                      title: 'Рейтинг',
                      value: stats.rating,
                    ),
                    ProfileStatWidget(
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
            card.titleHtml,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          HtmlWidget(
            card.descriptionHtml,
            textStyle: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          SubscribeButton(
            alias: card.alias,
            isSubscribed: (card.relatedData as CompanyRelatedData).isSubscribed,
          ),
        ],
      ),
    );
  }
}
