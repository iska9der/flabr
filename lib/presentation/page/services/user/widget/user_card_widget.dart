import 'package:flutter/material.dart';

import '../../../../../core/component/router/router.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../data/model/user/user.dart';
import '../../../../../di/di.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';
import '../../../publications/publication_detail_page.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key, required this.model});

  final User model;

  void moveToDetails(BuildContext context, String alias) {
    getIt<AppRouter>().navigate(
      UserDashboardRoute(alias: alias, children: [UserDetailRoute()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap: () => moveToDetails(context, model.alias),
      child: const Column(
        spacing: 10,
        children: [
          _UserCard(),
          _UserScore(),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
        User.empty;

    return Row(
      crossAxisAlignment: .start,
      children: [
        /// Аватар
        CardAvatarWidget(imageUrl: model.avatarUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              /// Полное имя
              /// Никнэйм
              RichText(
                text: TextSpan(
                  style: theme.textTheme.titleMedium,
                  text: model.fullname,
                  children: [
                    if (model.fullname.isNotEmpty) const TextSpan(text: ' '),
                    TextSpan(
                      text: '@${model.alias}',
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              /// Специализация
              Text(
                model.speciality.isNotEmpty ? model.speciality : 'Пользователь',
                style: theme.textTheme.bodySmall,
              ),

              /// Последний пост
              if (!model.lastPost.isEmpty)
                Padding(
                  padding: const .only(top: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(padding: .zero),
                    onPressed: () => getIt<AppRouter>().pushWidget(
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

    return Row(
      mainAxisAlignment: .center,
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
            triggerMode: .tap,
            child: ProfileStatCardWidget(
              type: StatType.score,
              title: 'Очки',
              value: model.score,
            ),
          ),
        ),
      ],
    );
  }
}
