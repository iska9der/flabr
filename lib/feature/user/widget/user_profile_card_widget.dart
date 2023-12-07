import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/num.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/profile_stat_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../common/profile_subscribe/repository/subscription_repository.dart';
import '../../common/profile_subscribe/widget/subscribe_button.dart';
import '../cubit/user_cubit.dart';
import '../repository/user_subscription_repository.dart';
import '../service/user_service.dart';

class UserProfileCardWidget extends StatefulWidget {
  const UserProfileCardWidget({super.key});

  @override
  State<UserProfileCardWidget> createState() => _UserProfileCardWidgetState();
}

class _UserProfileCardWidgetState extends State<UserProfileCardWidget> {
  @override
  void initState() {
    /// Регистрируем репозиторий подписки для [SubscribeButton]
    getIt.allowReassignment = true;
    getIt.registerFactory<SubscriptionRepository>(
      () => UserSubscriptionRepository(getIt.get<UserService>()),
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
    return FlabrCard(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          var model = state.model;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CardAvatarWidget(
                      imageUrl: model.avatarUrl,
                      height: 50,
                    ),
                  ),
                  Row(
                    children: [
                      ProfileStatWidget(
                        type: StatType.score,
                        title: 'Очки',
                        value: model.score,
                      ),
                      const SizedBox(width: 40),
                      Tooltip(
                        message: '${model.votesCount.compact()} голосов',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ProfileStatWidget(
                          type: StatType.rating,
                          title: 'Рейтинг',
                          value: model.rating,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (context.watch<AuthCubit>().state.isAuthorized)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SubscribeButton(
                    alias: model.alias,
                    isSubscribed: model.relatedData.isSubscribed,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
