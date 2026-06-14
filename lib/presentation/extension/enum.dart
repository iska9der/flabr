import 'package:flutter/material.dart';

import '../../data/model/publication/publication.dart';
import '../../data/model/stat_type_enum.dart';
import '../theme/extension/app_colors_extension.dart';

extension StatTypeExtension on StatType {
  Color? getColorByScore(num score, AppColorsExtension colors) {
    if (score >= 0) {
      return _getPositiveColor(colors);
    }

    return _getNegaviteColor(colors);
  }

  Color? _getPositiveColor(AppColorsExtension colors) {
    return switch (this) {
      .score => colors.accentPositive,
      .rating => colors.mulberry,
      _ => null,
    };
  }

  Color? _getNegaviteColor(AppColorsExtension colors) => switch (this) {
    .score => colors.accentDanger,
    _ => null,
  };
}

extension PublicationFormatExtension on PublicationFormat {
  Color getColor(AppColorsExtension colors) => switch (this) {
    .example || .digest || .opinion || .review => colors.portage,
    .faq || .roadmap || .tutorial => colors.sorbus,
    .interview || .reportage => colors.apple,
    .analytics || .retrospective => colors.mulberry,
  };
}
