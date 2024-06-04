import 'package:flutter/material.dart';

enum StatType {
  neutral,
  rating,
  score;

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
