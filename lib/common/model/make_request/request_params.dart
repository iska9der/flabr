import 'package:equatable/equatable.dart';

import 'params.dart';

class RequestParams extends Equatable {
  const RequestParams({
    this.params = const Params(),
  });

  final Params params;

  Map<String, dynamic> toMap() {
    return {
      'params': params.toMap(),
    };
  }

  factory RequestParams.fromMap(Map<String, dynamic> map) {
    return RequestParams(
      params: Params.fromMap(map['params']),
    );
  }

  @override
  List<Object> get props => [params];
}
