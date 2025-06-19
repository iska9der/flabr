import 'dart:async';

import 'package:collection/collection.dart';

class OffsetHistory {
  final Map<String, double> _data = {};

  final _stream = StreamController<OffsetHistory>();
  Stream<OffsetHistory> get stream => _stream.stream;

  void close() => _stream.close();

  void push(String id, double value) {
    _data[id] = value;
    _stream.add(this);
  }

  void remove(String id) {
    _data.remove(id);
    _stream.add(this);
  }

  double pop() {
    final value = _data.remove(_data.keys.last);
    if (value == null) {
      throw Exception('Пусто');
    }

    _stream.add(this);
    return value;
  }

  String? lessThan(double pixels) {
    final entry = _data.entries.firstWhereOrNull((e) => pixels > e.value);
    return entry?.key;
  }

  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  String toString() => _data.toString();
}
