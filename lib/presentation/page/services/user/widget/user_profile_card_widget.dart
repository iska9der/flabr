import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/auth/auth.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_widget.dart';

class UserProfileCardWidget extends StatefulWidget {
  const UserProfileCardWidget({super.key, required this.user});

  final User user;

  @override
  State<UserProfileCardWidget> createState() => _UserProfileCardWidgetState();
}

class _UserProfileCardWidgetState extends State<UserProfileCardWidget> {
  late final user = widget.user;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CardAvatarWidget(imageUrl: user.avatarUrl),
              ),
              Row(
                children: [
                  ProfileStatWidget(
                    type: StatType.rating,
                    title: 'Рейтинг',
                    value: user.rating,
                  ),
                  const SizedBox(width: 40),
                  Tooltip(
                    message: '${user.votesCount.compact()} голосов',
                    triggerMode: TooltipTriggerMode.tap,
                    child: ProfileStatWidget(
                      type: StatType.score,
                      title: 'Очки',
                      value: user.score,
                    ),
                  ),
                ],
              ),
            ],
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.me.alias == user.alias) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SubscribeButton(
                  alias: user.alias,
                  isSubscribed: user.relatedData.isSubscribed,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
