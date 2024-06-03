import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../core/component/di/injector.dart';
import '../../../data/model/stat_type.dart';
import '../../../data/repository/part.dart';
import '../../../presentation/theme/part.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../../../presentation/widget/feed/card_avatar_widget.dart';
import '../../../presentation/widget/profile_stat_widget.dart';
import '../../../presentation/widget/profile_subscribe/part.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/company_cubit.dart';
import '../model/card/company_card_statistics_model.dart';
import '../model/company_related_data.dart';

class CompanyProfileCardWidget extends StatefulWidget {
  const CompanyProfileCardWidget({super.key});

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
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        var card = state.card;
        var stats = card.statistics as CompanyCardStatisticsModel;

        return FlabrCard(
          padding: const EdgeInsets.symmetric(
            horizontal: kScreenHPadding,
            vertical: kScreenHPadding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CardAvatarWidget(
                    imageUrl: card.imageUrl,
                    height: 60,
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
                  )
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
              if (context.watch<AuthCubit>().state.isAuthorized) ...[
                const SizedBox(height: 8),
                SubscribeButton(
                  alias: state.alias,
                  isSubscribed:
                      (card.relatedData as CompanyRelatedData).isSubscribed,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
