import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/profile_stat_widget.dart';
import '../../../component/di/injector.dart';
import '../../../component/theme/theme_part.dart';
import '../../../data/repository/repository_part.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../common/profile_subscribe/widget/subscribe_button.dart';
import '../cubit/hub_cubit.dart';
import '../model/hub_related_data.dart';

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
