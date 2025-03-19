import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/repository/part.dart';
import '../../../../extension/extension.dart';
import '../../../../feature/auth/cubit/auth_cubit.dart';
import '../../../../feature/profile_subscribe/part.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_widget.dart';
import '../cubit/user_cubit.dart';

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
      () => UserSubscriptionRepository(getIt()),
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
                        type: StatType.rating,
                        title: 'Рейтинг',
                        value: model.rating,
                      ),
                      const SizedBox(width: 40),
                      Tooltip(
                        message: '${model.votesCount.compact()} голосов',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ProfileStatWidget(
                          type: StatType.score,
                          title: 'Очки',
                          value: model.score,
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
