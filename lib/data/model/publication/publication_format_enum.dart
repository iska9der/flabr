part of 'publication.dart';

@JsonEnum()
enum PublicationFormat {
  common,
  post,
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

  String get apiValue => this == example ? 'case' : name;

  String get label => switch (this) {
    common => t.publication.format.common,
    post => t.publication.type.post,
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
