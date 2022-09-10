import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'login_widget.dart';
import 'profile_widget.dart';

class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () async => showDialog(
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .8,
                  child: state.status.isAuthorized
                      ? const ProfileWidget()
                      : const LoginWidget(),
                ),
              ),
            ),
          ),
          icon: Icon(
            Icons.account_circle_rounded,
            color: state.status.isAuthorized ? Colors.green : null,
          ),
        );
      },
    );
  }
}
