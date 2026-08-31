import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/login_cubit.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../../i18n/i18n.dart';
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
                decoration: InputDecoration(
                  floatingLabelBehavior: .always,
                  labelText: context.t.auth.token.label(
                    sidToken: Keys.sidToken,
                  ),
                  hintText: context.t.auth.token.cookieHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (state.isAuthorized)
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().logOut(),
                      child: Text(context.t.common.clear),
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
                              );
                            },
                          },
                          child: Text(context.t.common.save),
                        );
                      },
                    ),
                  const SizedBox(width: 12),
                  if (state.isAuthorized)
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(.new(text: controller.text));

                        context.showSnack(
                          content: Text(context.t.common.copiedToClipboard),
                        );
                      },
                      child: Text(context.t.common.copy),
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
