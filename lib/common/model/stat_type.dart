import 'package:flutter/material.dart';

enum StatType { neutral, rating, score }

extension StatTypeX on StatType {
  Color? get color {
    switch (this) {
      case StatType.neutral:
        return null;
      case StatType.rating:
        return Colors.purple;
      case StatType.score:
        return Colors.green;
      default:
        return null;
    }
  }

  Color? get negativeColor {
    switch (this) {
      case StatType.neutral:
        break;
      case StatType.rating:
        break;
      case StatType.score:
        return Colors.red;
    }

    return null;
  }
}
