import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/user.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../../user/widget/user_avatar_widget.dart';
import '../cubit/auth_cubit.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.user});

  final UserBase user;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: UserAvatarWidget(imageUrl: user.avatarUrl),
              title: Text(user.fullname),
              subtitle: Text('@${user.alias}'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}',
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Статьи'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}/article',
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Закладки'),
              onTap: () {
                context.navigateNamedTo(
                  'services/users/${user.alias}/bookmarks',
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status.isUnauthorized) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.status.isUnauthorized) {
          return Wrap();
        }

        if (state.status.isLoading || state.me.isEmpty) {
          return const CircleIndicator.medium();
        }

        return Stack(
          children: [
            ProfileWidget(user: state.me),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ElevatedButton(
                onPressed: () => context.read<AuthCubit>().logOut(),
                child: const Text('Выход'),
              ),
            ),
          ],
        );
      },
    );
  }
}