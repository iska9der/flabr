// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class ListResponse<T> {
  const ListResponse({
    this.pagesCount = 1,
    this.ids = const [],
    this.refs = const [],
  });

  final int pagesCount;
  final List<String> ids;
  final List<T> refs;

  static const empty = ListResponse();

  ListResponse<T> copyWith({
    int? pagesCount,
    List<String>? ids,
    List<T>? refs,
  }) {
    return ListResponse<T>(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: UnmodifiableListView(ids ?? this.ids),
      refs: UnmodifiableListView(refs ?? this.refs),
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
