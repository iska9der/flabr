import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/profile/profile_bloc.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_detail_widget.dart';

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
    super.initState();

    /// Регистрируем репозиторий подписки для [SubscribeButton]
    getIt.allowReassignment = true;
    getIt.registerFactory<SubscriptionRepository>(
      () => UserSubscriptionRepository(getIt()),
    );
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

    return FlabrCard(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            spacing: 20,
            children: [
              CardAvatarWidget(imageUrl: user.avatarUrl),
              Row(
                children: [
                  ProfileStatDetailWidget(
                    type: StatType.rating,
                    title: 'Рейтинг',
                    value: user.rating,
                  ),
                  const SizedBox(width: 40),
                  Tooltip(
                    message: '${user.votesCount.compact()} голосов',
                    triggerMode: .tap,
                    child: ProfileStatDetailWidget(
                      type: StatType.score,
                      title: 'Очки',
                      value: user.score,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (user.fullname.isNotEmpty)
            FittedBox(
              fit: .scaleDown,
              alignment: .topLeft,
              child: Text(
                user.fullname,
                style: theme.textTheme.headlineSmall,
              ),
            ),
          Text(
            '@${user.alias}',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Text(
            user.speciality.isNotEmpty ? user.speciality : 'Пользователь',
            style: theme.textTheme.labelLarge,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.me.alias == user.alias) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const .only(top: 16),
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
