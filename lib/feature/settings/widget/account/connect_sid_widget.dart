import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/utils.dart';
import '../../../../component/di/dependencies.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/login_cubit.dart';
import '../../../auth/repository/token_repository.dart';
import '../settings_card_widget.dart';

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
      create: (_) => LoginCubit(
        tokenRepository: getIt.get<TokenRepository>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (_, current) => current.status == LoginStatus.success,
        listener: (_, state) => context.read<AuthCubit>().handleAuthData(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final loginCubit = context.read<LoginCubit>();

            if (state.isAuthorized) {
              controller.text = state.data.connectSID;
            } else {
              controller.text = '';
            }

            return SettingsCardWidget(
              title: 'connect_sid token',
              subtitle: 'Если не удается войти через форму логина',
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
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
                                  loginCubit.submitConnectSid(controller.text);
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
                              getIt.get<Utils>().showSnack(
                                    context: context,
                                    content: const Text(
                                      'Скопировано в буфер обмена',
                                    ),
                                  );
                            },
                            child: const Text('Скопировать'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
