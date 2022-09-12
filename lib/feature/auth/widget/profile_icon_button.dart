import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../utils/profile_dialog.dart';
import 'login_widget.dart';
import 'profile_widget.dart';

class MyProfileIconButton extends StatelessWidget {
  const MyProfileIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () async => await showProfileDialog(
            context,
            child: state.status.isAuthorized
                ? const MyProfileWidget()
                : const LoginWidget(),
          ),
          icon: Icon(
            Icons.account_circle_rounded,
            color: state.status.isAuthorized
                ? Theme.of(context).primaryColor
                : null,
          ),
        );
      },
    );
  }
}
