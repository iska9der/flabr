import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/di/di.dart';
import '../../../../../data/model/company/card/company_card_model.dart';
import '../../../../../data/model/related_data/company_related_data_model.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../feature/auth/auth.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_widget.dart';
import '../cubit/company_cubit.dart';

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
        var stats = card.statistics as CompanyCardStatistics;

        return FlabrCard(
          padding: AppInsets.profileCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CardAvatarWidget(imageUrl: card.imageUrl, height: 60),
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
