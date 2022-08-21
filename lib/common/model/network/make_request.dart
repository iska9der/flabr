import 'package:equatable/equatable.dart';

import 'request_params.dart';

class MakeRequest extends Equatable {
  const MakeRequest({
    required this.method,
    this.version = '2',
    this.connectSSID,
    required this.requestParams,
  });

  final String method;
  final String version;
  final String? connectSSID;

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
