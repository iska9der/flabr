import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/profile/profile_bloc.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/profile_subscribe/profile_subscribe.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class UserProfileCardWidget extends StatefulWidget {
  const UserProfileCardWidget({super.key, required this.user});

  final User user;

  @override
  State<UserProfileCardWidget> createState() => _UserProfileCardWidgetState();
}

class _UserProfileCardWidgetState extends State<UserProfileCardWidget> {
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
    final translation = context.t;
    final user = widget.user;

    return FlabrCard(
      padding: AppInsets.md,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              CardAvatarWidget(imageUrl: user.avatarUrl),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 2,
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 6,
            children: [
              if (user.reach case final reach? when reach.isNotEmpty)
                Expanded(
                  child: ProfileStatCardWidget(
                    title: translation.common.reach,
                    value: reach,
                    valueColor: theme.colors.accentPrimary,
                  ),
                ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: translation.user.rating,
                  value: user.rating.toString(),
                  valueColor: StatType.rating.getColorByScore(
                    user.rating,
                    theme.colors,
                  ),
                ),
              ),
              Expanded(
                child: Tooltip(
                  message: translation.user.profile.votes(
                    votesCount: user.votesCount.compact(),
                  ),
                  triggerMode: .tap,
                  child: ProfileStatCardWidget(
                    title: translation.user.points,
                    value: user.score.compact(),
                    valueColor: StatType.score.getColorByScore(
                      user.score,
                      theme.colors,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            user.speciality.isNotEmpty ? user.speciality : context.t.user.role,
            style: theme.textTheme.labelLarge,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.me.alias == user.alias) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const .only(top: 12),
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
