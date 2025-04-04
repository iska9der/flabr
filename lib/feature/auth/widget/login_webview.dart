import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/component/logger/logger.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';
import 'profile_widget.dart';

class LoginWebView extends StatelessWidget implements DialogUserWidget {
  const LoginWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlabrCard(
        padding: EdgeInsets.zero,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.isAuthorized) {
              return Center(child: Text('Вы уже вошли, ${state.me.alias}'));
            }

            return BlocProvider(
              create: (_) => LoginCubit(tokenRepository: getIt()),
              child: BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status.isSuccess) {
                    context.read<AuthCubit>().handleTokens();

                    Navigator.of(context).pop();
                  }
                },
                child: const _WebViewLogin(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WebViewLogin extends StatefulWidget {
  const _WebViewLogin();

  @override
  State<_WebViewLogin> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends State<_WebViewLogin> {
  late final WebViewController wvController;
  late final WebviewCookieManager cookieManager;

  final Uri _authUri = Uri.parse(
    '${Urls.siteApiUrl}/v1/auth/habrahabr/?back=/ru/all',
  );

  @override
  void dispose() {
    _clearControllerData();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    cookieManager = WebviewCookieManager();
    wvController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) async {
                logger.info(request.url, title: 'URL');

                if (request.url.startsWith('${Urls.baseUrl}/ru/all')) {
                  final loginCubit = context.read<LoginCubit>();
                  await getConnectSid(request.url).then(
                    (value) => Timer(
                      const Duration(seconds: 1),
                      () => loginCubit.submitConnectSid(value),
                    ),
                  );
                  return NavigationDecision.prevent;
                }

                if (!request.url.startsWith(Urls.baseUrl) &&
                    !request.url.startsWith('https://account.habr.com')) {
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(_authUri);
  }

  Future<String> getConnectSid(String url) async {
    final list = await cookieManager.getCookies(url);
    final sid =
        list
            .firstWhere(
              (cookie) => cookie.name == 'connect_sid',
              orElse: () => Cookie('bababoi', ''),
            )
            .value;

    return sid;
  }

  void _clearControllerData() async {
    await wvController.clearCache();
    await wvController.clearLocalStorage();
    await cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (_, current) => current.status.isFailure,
        listener: (context, state) {
          _clearControllerData();
          context.showSnack(
            content: Text(state.error),
            duration: const Duration(seconds: 5),
          );
          wvController.loadRequest(_authUri);
        },
        child: WebViewWidget(controller: wvController),
      ),
    );
  }
}
