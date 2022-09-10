import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../cubit/auth_cubit.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

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

        if (state.status.isLoading) {
          return const CircleIndicator.medium();
        }

        return FlabrCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.read<AuthCubit>().logOut(),
                child: const Text('Выход'),
              ),
            ],
          ),
        );
      },
    );
  }
}
