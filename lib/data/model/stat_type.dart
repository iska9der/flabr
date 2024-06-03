import 'package:flutter/material.dart';

enum StatType { neutral, rating, score }

extension StatTypeX on StatType {
  Color? get color => switch (this) {
        StatType.rating => Colors.purple,
        StatType.score => Colors.green,
        _ => null,
      };

  Color? get negativeColor => switch (this) {
        StatType.score => Colors.red,
        _ => null,
      };
}
