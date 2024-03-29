import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/extension/num.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/profile_stat_card_widget.dart';
import '../../../component/router/app_router.dart';
import '../model/user_model.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key, required this.model});

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _UserCard(),
        _UserScore(),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard();

  void _pushDetails(BuildContext context, String alias) {
    context.router.navigateNamed('services/users/$alias/detail');
  }

  @override
  Widget build(BuildContext context) {
    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
            UserModel.empty;

    return FlabrCard(
      onTap: () => _pushDetails(context, model.alias),
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
                      )
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
                      onPressed: () => context.navigateTo(ArticlesRouter(
                        children: [ArticleDetailRoute(id: model.lastPost.id)],
                      )),
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
            UserModel.empty;

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
