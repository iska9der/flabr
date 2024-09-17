// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListResponse {
  const ListResponse({
    this.pagesCount = 1,
    this.ids = const [],
    this.refs = const [],
  });

  final int pagesCount;
  final List<String> ids;
  final List refs;

  static const empty = ListResponse();

  copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return ListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: refs ?? this.refs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pagesCount': pagesCount,
      'ids': ids,
      'refs': refs,
    };
  }

  String toJson() => json.encode(toMap());
}
