import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/stat_type.dart';
import '../../../config/constants.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/profile_stat_widget.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../user/widget/user_avatar_widget.dart';
import '../cubit/hub_cubit.dart';
import 'hub_subscribe_button.dart';

class HubProfileCardWidget extends StatelessWidget {
  const HubProfileCardWidget({Key? key}) : super(key: key);

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
                  UserAvatarWidget(
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
                style: Theme.of(context).textTheme.caption,
              ),
              if (context.watch<AuthCubit>().state.isAuthorized) ...[
                const SizedBox(height: 8),
                const HubSubscribeButton(),
              ],
            ],
          ),
        );
      },
    );
  }
}
