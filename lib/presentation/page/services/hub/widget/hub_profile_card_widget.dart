import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../data/model/related_data/hub_related_data_model.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/part.dart';
import '../../../../feature/auth/cubit/auth_cubit.dart';
import '../../../../feature/profile_subscribe/part.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_widget.dart';
import '../cubit/hub_cubit.dart';

class HubProfileCardWidget extends StatefulWidget {
  const HubProfileCardWidget({super.key});

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
    return BlocBuilder<HubCubit, HubState>(
      builder: (context, state) {
        var profile = state.profile;
        var stats = profile.statistics;

        return FlabrCard(
          padding: AppInsets.profileCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CardAvatarWidget(
                    imageUrl: profile.imageUrl,
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
                profile.descriptionHtml,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                profile.fullDescriptionHtml,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (context.watch<AuthCubit>().state.isAuthorized) ...[
                const SizedBox(height: 8),
                SubscribeButton(
                  alias: state.alias,
                  isSubscribed: (state.profile.relatedData as HubRelatedData)
                      .isSubscribed,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
