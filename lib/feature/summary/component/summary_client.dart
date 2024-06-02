import 'package:dio/dio.dart';

import '../../../component/http/http_part.dart';
import '../data/summary_token_repository.dart';

class SummaryClient extends DioClient {
  SummaryClient(super.client, {required this.tokenRepository}) {
    client.options = client.options.copyWith(baseUrl: 'https://300.ya.ru/api');

    client.interceptors.clear();
    client.interceptors.add(_interceptor());
  }

  final SummaryTokenRepository tokenRepository;

  Interceptor _interceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        String? token = await tokenRepository.getToken();

        if (token != null) {
          request.headers['Authorization'] = 'OAuth $token';
          return handler.next(request);
        }

        handler.next(request);
      },
    );
  }
}
