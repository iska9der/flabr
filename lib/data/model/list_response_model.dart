// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../core/component/logger/logger.dart';
import '../../di/di.dart';

class ListResponse<T> {
  const ListResponse({
    this.pagesCount = 0,
    this.ids = const [],
    this.refs = const [],
  });

  final int pagesCount;
  final List<String> ids;
  final List<T> refs;

  static const empty = ListResponse<dynamic>();

  ListResponse<T> copyWith({
    int? pagesCount,
    List<String>? ids,
    List<T>? refs,
  }) {
    return ListResponse<T>(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: refs ?? this.refs,
    );
  }

  /// [getId] используется для проверки и фильтра дубликатов.
  /// В коллбэке нужно возвращать идентификатор элемента.
  /// Если он не предоставлен, то элементы из [other] будут добавлены без проверки на дубликаты.
  ListResponse<T> merge(
    ListResponse<T> other, {
    String Function(T ref)? getId,
  }) {
    final newIds = <String>{...ids, ...other.ids}.toList();

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('refs: \t\t\t${refs.length}');

    List<T> otherRefs = other.refs;
    buffer.writeln('other: \t\t\t${otherRefs.length}');

    if (getId != null) {
      final intersection = ids.toSet().intersection(other.ids.toSet());
      buffer.writeln('intersected: \t\t${intersection.length}');

      otherRefs = otherRefs
          .where((ref) => !intersection.contains(getId(ref)))
          .toList();
      buffer.writeln('other filtered: \t\t${otherRefs.length}');
    }

    final resolvedRefs = [...refs, ...otherRefs];
    buffer.writeln('resolved: \t\t${resolvedRefs.length}');

    getIt<Logger>().info(buffer.toString());

    return ListResponse<T>(
      pagesCount: other.pagesCount,
      ids: newIds,
      refs: resolvedRefs,
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
