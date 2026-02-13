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

  /// Разрешенные домены OAuth провайдеров для внешней авторизации
  static const _allowedOAuthDomains = [
    'github.com',
    'google.com',
    'vk.com',
    'yandex.ru',
    'facebook.com',
    'x.com',
    'twitter.com',
  ];

  bool _isAllowedUrl(String url) {
    /// Всегда разрешаем домены Habr
    if (url.startsWith(Urls.baseUrl) ||
        url.startsWith('https://account.habr.com')) {
      return true;
    }

    final uri = Uri.parse(url);

    /// Разрешаем известные OAuth провайдеры
    /// Проверяем хост, чтобы избежать обхода через параметры (например, ?q=google.com)
    return _allowedOAuthDomains.any(
      (domain) => uri.host == domain || uri.host.endsWith('.$domain'),
    );
  }

  @override
  void dispose() {
    _clearControllerData();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    cookieManager = WebviewCookieManager();
    wvController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;

            logger.info(url, title: 'URL');

            final uri = Uri.parse(url);

            final isFeed = url.startsWith('${Urls.baseUrl}/ru/all');

            if (isFeed) {
              final loginCubit = context.read<LoginCubit>();
              final hasCode = uri.queryParameters.containsKey('code');
              final hasState = uri.queryParameters.containsKey('state');

              /// Форма авторизации (без параметров) - сохраняем токен
              if (!hasCode && !hasState) {
                final token = await handleCookies(url);
                loginCubit.submit(token: token);
                return NavigationDecision.navigate;
              }

              /// OAuth:
              /// - только с code (промежуточный редирект) - пускаем дальше
              /// - с code и state - сохраняем токен
              if (hasCode) {
                if (hasState) {
                  final token = await handleCookies(url);
                  loginCubit.submit(token: token);
                }
                return NavigationDecision.navigate;
              }
            }

            /// Разрешаем навигацию только на домены Habr и известные OAuth провайдеры
            if (!_isAllowedUrl(url)) {
              logger.info('URL не разрешен');

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
