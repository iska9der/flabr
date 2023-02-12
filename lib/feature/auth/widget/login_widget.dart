import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../component/di/dependencies.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';
import '../repository/auth_repository.dart';
import '../repository/token_repository.dart';
import 'profile_widget.dart';

class LoginWidget extends StatelessWidget implements DialogUserWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;

    return Center(
      child: FlabrCard(
        padding: const EdgeInsets.all(20),
        child: authState.isAuthorized
            ? Center(child: Text('Вы уже вошли, ${authState.me.alias}'))
            : BlocProvider(
                create: (context) => LoginCubit(
                  repository: getIt.get<AuthRepository>(),
                  tokenRepository: getIt.get<TokenRepository>(),
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
              ),
      ),
    );
  }
}

class _LoginWidgetView extends StatelessWidget {
  const _LoginWidgetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Вход',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 18),
        const _LoginField(),
        const SizedBox(height: 18),
        const _PasswordField(),
        const SizedBox(height: 24),
        const _ErrorWidget(),
        const SizedBox(height: 18),
        const _SubmitButton(),
      ],
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
          decoration: InputDecoration(
            label: const Text('Почта'),
            prefixIcon: const Icon(Icons.email_outlined),
            border: const OutlineInputBorder(),
            errorText: state.loginError.isNotEmpty ? state.loginError : null,
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
          decoration: InputDecoration(
            label: const Text('Пароль'),
            prefixIcon: const Icon(Icons.password_outlined),
            border: const OutlineInputBorder(),
            errorText:
                state.passwordError.isNotEmpty ? state.passwordError : null,
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

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return Text(
            state.error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }

        return const SizedBox();
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: state.status.isLoading
                  ? null
                  : () => context.read<LoginCubit>().submit(),
              child: state.status.isLoading
                  ? const CircleIndicator.small()
                  : const Text('Войти'),
            ),
            OutlinedButton(
              onPressed: state.status.isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      context.router.navigateNamed('settings');
                    },
              child: const Text('Войти по токену'),
            ),
          ],
        );
      },
    );
  }
}
