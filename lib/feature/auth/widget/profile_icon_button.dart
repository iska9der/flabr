import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'dialog.dart';
import 'profile_widget.dart';

class MyProfileIconButton extends StatelessWidget {
  const MyProfileIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => state.isAuthorized
              ? showProfileDialog(context, child: const DialogMyProfileWidget())
              : showLoginDialog(context),
          icon: Icon(
            Icons.account_circle_rounded,
            color: state.isAuthorized ? Theme.of(context).primaryColor : null,
          ),
        );
      },
    );
  }
}
