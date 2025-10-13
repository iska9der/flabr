import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/login_cubit.dart';
import '../../../core/constants/constants.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';

class ConnectSidWidget extends StatefulWidget {
  const ConnectSidWidget({super.key});

  @override
  State<ConnectSidWidget> createState() => _ConnectSidWidgetState();
}

class _ConnectSidWidgetState extends State<ConnectSidWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(tokenRepository: getIt()),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.unauthorized) {
            controller.text = '';
          } else {
            controller.text = state.token;
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                enabled: !state.isAuthorized,
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Токен ${Keys.sidToken}',
                  hintText: 'Можно найти в cookies',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  state.isAuthorized
                      ? ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().logOut();
                        },
                        child: const Text('Очистить'),
                      )
                      : BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return FilledButton(
                            onPressed:
                                state.status == LoadingStatus.loading
                                    ? null
                                    : () {
                                      context.read<LoginCubit>().handle(
                                        token: controller.text,
                                        isManual: true,
                                      );
                                    },
                            child: const Text('Сохранить'),
                          );
                        },
                      ),
                  const SizedBox(width: 12),
                  if (state.isAuthorized)
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.text));
                        context.showSnack(
                          content: const Text('Скопировано в буфер обмена'),
                        );
                      },
                      child: const Text('Скопировать'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
