import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../bloc/auth/login_cubit.dart';
import '../../../core/component/logger/logger.dart';
import '../../../core/constants/constants.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/repository/repository.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';
import '../enhancement/card.dart';

class LoginWebView extends StatelessWidget {
  const LoginWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlabrCard(
        padding: EdgeInsets.zero,
        child: BlocProvider(
          create: (_) => LoginCubit(tokenRepository: getIt()),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoadingStatus.success) {
                Navigator.of(context).pop();
              }
            },
            child: const _WebViewLogin(),
          ),
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
                  final token = await handleCookies(request.url);
                  await loginCubit.handle(token: token);

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

  Future<String> handleCookies(String url) async {
    final list = await cookieManager.getCookies(url);

    final cookieJar = getIt<TokenRepository>().cookieJar;
    await cookieJar.saveFromResponse(Uri.parse(Urls.baseUrl), list);
    await cookieJar.saveFromResponse(Uri.parse(Urls.mobileBaseUrl), list);
    return list.firstWhere((element) => element.name == Keys.sidToken).value;
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
        listenWhen: (_, current) => current.status == LoadingStatus.failure,
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
