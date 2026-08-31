part of 'publication.dart';

@JsonEnum()
enum PublicationFormat {
  @JsonValue('case')
  example,
  tutorial,
  faq,
  review,
  opinion,
  digest,
  analytics,
  roadmap,
  reportage,
  interview,
  retrospective;

  String get label => switch (this) {
    example => t.publication.format.caseStudy,
    tutorial => t.publication.format.tutorial,
    faq => 'FAQ',
    review => t.publication.format.review,
    opinion => t.publication.format.opinion,
    digest => t.publication.format.digest,
    analytics => t.publication.format.analytics,
    roadmap => t.publication.format.roadmap,
    reportage => t.publication.format.report,
    interview => t.publication.format.interview,
    retrospective => t.publication.format.retrospective,
  };
}
