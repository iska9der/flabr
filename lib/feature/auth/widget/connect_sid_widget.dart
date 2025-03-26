import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../../presentation/extension/extension.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';

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
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (_, current) => current.status == LoginStatus.success,
        listener: (_, state) => context.read<AuthCubit>().handleTokens(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.unauthorized) {
              controller.text = '';
            } else {
              controller.text = state.tokens.connectSID;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  enabled: !state.isAuthorized,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Токен connect_sid',
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
                        : FilledButton(
                          onPressed: () {
                            context.read<LoginCubit>().submitConnectSid(
                              controller.text,
                            );
                          },
                          child: const Text('Сохранить'),
                        ),
                    const SizedBox(width: 12),
                    if (state.isAuthorized)
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: controller.text),
                          );
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
      ),
    );
  }
}
