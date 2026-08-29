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
    example => t.publication.formatCaseStudy,
    tutorial => t.publication.formatTutorial,
    faq => 'FAQ',
    review => t.publication.formatReview,
    opinion => t.publication.formatOpinion,
    digest => t.publication.formatDigest,
    analytics => t.publication.formatAnalytics,
    roadmap => t.publication.formatRoadmap,
    reportage => t.publication.formatReport,
    interview => t.publication.formatInterview,
    retrospective => t.publication.formatRetrospective,
  };
}
