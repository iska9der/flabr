import 'package:flutter/material.dart';

import '../../../../../core/component/di/di.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';
import '../../../publications/publication_detail_page.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key, required this.model});

  final User model;

  @override
  Widget build(BuildContext context) {
    return const Column(children: [_UserCard(), _UserScore()]);
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard();

  void moveToDetails(BuildContext context, String alias) {
    getIt<AppRouter>().navigate(
      UserDashboardRoute(alias: alias, children: [UserDetailRoute()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
        User.empty;

    return FlabrCard(
      onTap: () => moveToDetails(context, model.alias),
      child: Row(
        children: [
          /// Аватар
          CardAvatarWidget(imageUrl: model.avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Полное имя
                /// Никнэйм
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    text: model.fullname,
                    children: [
                      if (model.fullname.isNotEmpty) const TextSpan(text: ', '),
                      TextSpan(
                        text: '@${model.alias}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                /// Специализация
                Text(
                  model.speciality.isNotEmpty
                      ? model.speciality
                      : 'Пользователь',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                /// Последний пост
                if (!model.lastPost.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextButton(
                      onPressed:
                          () => getIt<AppRouter>().pushWidget(
                            PublicationDetailPage(
                              id: model.lastPost.id,
                              type: model.lastPost.type.name,
                            ),
                          ),
                      child: Text(model.lastPost.titleHtml),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserScore extends StatelessWidget {
  const _UserScore();

  @override
  Widget build(BuildContext context) {
    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
        User.empty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ProfileStatCardWidget(
              type: StatType.rating,
              title: 'Рейтинг',
              value: model.rating,
            ),
          ),
          Expanded(
            child: Tooltip(
              message: '${model.votesCount.compact()} голосов',
              triggerMode: TooltipTriggerMode.tap,
              child: ProfileStatCardWidget(
                type: StatType.score,
                title: 'Очки',
                value: model.score,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
