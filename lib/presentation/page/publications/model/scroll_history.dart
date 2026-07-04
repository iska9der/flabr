import 'dart:async';

class CommentScrollHistory {
  // История работает как стек уникальных commentId
  final _data = <String>[];
  final _stream = StreamController<CommentScrollHistory>();

  Stream<CommentScrollHistory> get stream => _stream.stream;

  bool get isEmpty => _data.isEmpty;

  void close() => _stream.close();

  void push(String commentId) {
    // Повторный переход к комментарию делает его последней точкой возврата
    _data.remove(commentId);
    _data.add(commentId);
    _stream.add(this);
  }

  void removeVisibleBefore({
    required int firstVisibleIndex,
    required int Function(String commentId) indexOf,
  }) {
    final initialCount = _data.length;

    // Пройденные пользователем позиции больше не должны показывать кнопку возврата
    _data.removeWhere((commentId) {
      final index = indexOf(commentId);

      return index != -1 && index < firstVisibleIndex;
    });

    if (_data.length != initialCount) {
      _stream.add(this);
    }
  }

  String pop() {
    if (_data.isEmpty) {
      throw Exception('Пусто');
    }

    final value = _data.removeLast();
    _stream.add(this);

    return value;
  }
}
