import 'package:equatable/equatable.dart';

import 'request_params.dart';

/// эти классы [MakeRequest], [RequestParams] нужны нам
/// для составлений запросов на proxy клиент
class MakeRequest extends Equatable {
  const MakeRequest({
    required this.method,
    this.version = '2',
    this.connectSSID,
    required this.requestParams,
  });

  /// путь на habr, куда летит запрос через прокси
  /// например: articles, users
  final String method;

  /// версия api
  final String version;

  /// токен авторизации
  final String? connectSSID;

  /// параметры запроса
  final RequestParams requestParams;

  Map<String, dynamic> toMap() {
    final rParams = requestParams.toMap();

    return {
      'method': method,
      'version': version,
      'connectSSID': connectSSID,
      'requestParams': rParams,
    };
  }

  factory MakeRequest.fromMap(Map<String, dynamic> map) {
    return MakeRequest(
      method: map['method'] as String,
      version: map['version'] as String,
      connectSSID: map['connectSSID'] as String,
      requestParams: map['requestParams'] as RequestParams,
    );
  }

  @override
  List<Object?> get props => [method, version, connectSSID, requestParams];
}
