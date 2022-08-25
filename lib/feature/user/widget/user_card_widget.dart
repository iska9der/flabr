import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../component/router/router.dart';
import '../../../config/constants.dart';
import '../../../page/users/user_detail_page.dart';
import '../model/user_model.dart';
import 'user_avatar_widget.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget(this.model, {Key? key}) : super(key: key);

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kCardOuterPadding,
        vertical: kCardOuterPadding * 2,
      ),
      child: Column(
        children: const [
          _UserCard(),
          _UserScore(),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({Key? key}) : super(key: key);

  void _pushDetails(BuildContext context, String alias) {
    context.router.pushWidget(UserDetailPage(login: alias));
  }

  @override
  Widget build(BuildContext context) {
    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
            UserModel.empty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _pushDetails(context, model.alias),
        child: Padding(
          padding: const EdgeInsets.all(kCardInnerPadding),
          child: Row(
            children: [
              /// Аватар
              UserAvatarWidget(imageUrl: model.avatar),
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
                        text: model.fullName,
                        children: [
                          if (model.fullName.isNotEmpty)
                            const TextSpan(text: ', '),
                          TextSpan(
                            text: '@${model.alias}',
                            style: Theme.of(context).textTheme.caption,
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
                      style: Theme.of(context).textTheme.caption,
                    ),

                    /// Последний пост
                    if (!model.lastPost.isEmpty) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          context.navigateTo(
                            ArticlesRoute(children: [
                              ArticleDetailRoute(
                                key: ValueKey('article-${model.lastPost.id}'),
                                id: model.lastPost.id,
                              ),
                            ]),
                          );
                        },
                        child: Text(model.lastPost.titleHtml),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserScore extends StatelessWidget {
  const _UserScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =
        context.findAncestorWidgetOfExactType<UserCardWidget>()?.model ??
            UserModel.empty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCard(context, 'Рейтинг', model.rating.toString()),
        _buildCard(context, 'Очки', model.score.toString()),
      ],
    );
  }

  Expanded _buildCard(BuildContext context, String title, String text) {
    return Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Align(
              child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          )),
        ],
      ),
    );
  }
}
