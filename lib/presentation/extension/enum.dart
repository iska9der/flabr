import 'package:flutter/material.dart';

import '../../data/model/publication/publication.dart';
import '../../data/model/stat_type_enum.dart';
import '../theme/app_colors.dart';

extension StateStatusExtension on Enum {
  bool get isInitial => name == 'initial';
  bool get isLoading => name == 'loading';
  bool get isSuccess => name == 'success';
  bool get isFailure => name == 'failure';
}

extension StatTypeExtension on StatType {
  Color? getColorByScore(num score, AppColors colors) => switch (score) {
    >= 0 => _getPositiveColor(colors),
    _ => _getNegaviteColor(colors),
  };

  Color? _getPositiveColor(AppColors colors) => switch (this) {
    StatType.score => colors.highlight,
    StatType.rating => colors.mulberry,
    _ => null,
  };

  Color? _getNegaviteColor(AppColors colors) => switch (this) {
    StatType.score => colors.carnation,
    _ => null,
  };
}

extension PublicationFormatExtension on PublicationFormat {
  Color getColor(AppColors colors) => switch (this) {
    PublicationFormat.example ||
    PublicationFormat.digest ||
    PublicationFormat.opinion ||
    PublicationFormat.review => colors.portage,
    PublicationFormat.faq ||
    PublicationFormat.roadmap ||
    PublicationFormat.tutorial => colors.sorbus,
    PublicationFormat.interview || PublicationFormat.reportage => colors.apple,
    PublicationFormat.analytics ||
    PublicationFormat.retrospective => colors.mulberry,
  };
}
