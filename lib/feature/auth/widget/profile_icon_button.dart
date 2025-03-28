import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/extension/context.dart';
import '../../../presentation/widget/card_avatar_widget.dart';
import '../cubit/auth_cubit.dart';
import 'dialog.dart';
import 'profile_widget.dart';

class MyProfileIconButton extends StatelessWidget {
  const MyProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed:
              state.isAuthorized
                  ? () => showProfileDialog(
                    context,
                    child: const DialogMyProfileWidget(),
                  )
                  : () => showLoginDialog(context),
          icon:
              state.isAuthorized
                  ? CardAvatarWidget(
                    imageUrl: state.me.avatarUrl,
                    placeholderColor: context.theme.colorScheme.primary,
                    height: context.theme.iconTheme.size ?? 24,
                  )
                  : Icon(Icons.no_accounts_rounded),
        );
      },
    );
  }
}
