import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../component/di/dependencies.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';
import '../service/auth_service.dart';
import '../service/token_service.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        service: getIt.get<AuthService>(),
        tokenService: getIt.get<TokenService>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pop();

            context.read<AuthCubit>().handleAuthData();
          }
        },
        child: const _LoginWidgetView(),
      ),
    );
  }
}

class _LoginWidgetView extends StatelessWidget {
  const _LoginWidgetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .8,
        child: FlabrCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Авторизация',
                style: Theme.of(context).textTheme.headline5,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 18),
                    const _LoginField(),
                    const SizedBox(height: 18),
                    const _PasswordField(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: BlocBuilder<LoginCubit, LoginState>(
                        buildWhen: (p, c) => p.status != c.status,
                        builder: (context, state) {
                          if (state.status.isFailure) {
                            return Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            );
                          }

                          return Wrap();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.login != c.login,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.login,
          decoration: const InputDecoration(
            label: Text('Почта'),
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          onChanged: (String value) {
            context.read<LoginCubit>().onLoginChanged(value);
          },
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password,
          decoration: const InputDecoration(
            label: Text('Пароль'),
            prefixIcon: Icon(Icons.password_outlined),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: (value) {
            context.read<LoginCubit>().onPasswordChanged(value);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status.isLoading
              ? null
              : () => context.read<LoginCubit>().submit(),
          child: state.status.isLoading
              ? const CircleIndicator.small()
              : const Text('Войти'),
        );
      },
    );
  }
}
