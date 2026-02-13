import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/login_cubit.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';

class ConnectSidWidget extends StatefulWidget {
  const ConnectSidWidget({super.key});

  @override
  State<ConnectSidWidget> createState() => _ConnectSidWidgetState();
}

class _ConnectSidWidgetState extends State<ConnectSidWidget> {
  late final TextEditingController controller = .new();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(tokenRepository: getIt()),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          controller.text = switch (state.status == .unauthorized) {
            true => '',
            false => state.token,
          };

          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              TextFormField(
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                enabled: !state.isAuthorized,
                controller: controller,
                keyboardType: .text,
                decoration: const .new(
                  floatingLabelBehavior: .always,
                  labelText: 'Токен ${Keys.sidToken}',
                  hintText: 'Можно найти в cookies',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (state.isAuthorized)
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().logOut(),
                      child: const Text('Очистить'),
                    )
                  else
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return FilledButton(
                          onPressed: switch (state.status == .loading) {
                            true => null,
                            false => () {
                              context.read<LoginCubit>().submit(
                                token: controller.text,
                                isManual: true,
                              );
                            },
                          },
                          child: const Text('Сохранить'),
                        );
                      },
                    ),
                  const SizedBox(width: 12),
                  if (state.isAuthorized)
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(.new(text: controller.text));

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
