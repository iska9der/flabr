import 'package:equatable/equatable.dart';

class QueryParams extends Equatable {
  const QueryParams({this.page = ''});

  final String page;

  factory QueryParams.fromMap(Map<String, dynamic> map) {
    return QueryParams(page: map['page'] ?? '');
  }

  String toQueryString() {
    return 'page=$page';
  }

  Map<String, dynamic> toMap() {
    final asString = toQueryString();
    final uri = Uri(query: asString);

    return {...uri.queryParameters};
  }

  @override
  List<Object?> get props => [page];
}
