import 'package:flutter/material.dart';

import '../../data/model/publication/publication.dart';
import '../../data/model/stat_type_enum.dart';

extension StateStatusX on Enum {
  bool get isInitial => name == 'initial';
  bool get isLoading => name == 'loading';
  bool get isSuccess => name == 'success';
  bool get isFailure => name == 'failure';
}

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

extension PublicationFormatX on PublicationFormat {
  Color get color => switch (this) {
    PublicationFormat.example ||
    PublicationFormat.digest ||
    PublicationFormat.opinion ||
    PublicationFormat.review => const Color(0xff2385e7),
    PublicationFormat.faq ||
    PublicationFormat.roadmap ||
    PublicationFormat.tutorial => const Color(0xffd5700b),
    PublicationFormat.interview || PublicationFormat.reportage => const Color(
      0xff1da53d,
    ).withValues(alpha: .7),
    PublicationFormat.analytics ||
    PublicationFormat.retrospective => const Color(0xffc23d96),
  };
}
