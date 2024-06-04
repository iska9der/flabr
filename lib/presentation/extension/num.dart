
part of 'part.dart';

extension NumX on num {
  String compact() {
    final formatter = NumberFormat.compact();

    return formatter.format(this).toString();
  }
}
