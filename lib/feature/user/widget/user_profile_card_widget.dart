import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/profile_stat_widget.dart';
import '../../../config/constants.dart';
import '../cubit/user_cubit.dart';

class UserProfileCardWidget extends StatelessWidget {
  const UserProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      padding: const EdgeInsets.all(kCardPadding),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          var model = state.model;

          return Row(
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
                  ProfileStatWidget(
                    type: StatType.rating,
                    title: 'Рейтинг',
                    value: model.rating,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
