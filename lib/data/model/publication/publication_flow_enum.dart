part of 'publication.dart';

enum PublicationFlow {
  all,
  develop,
  admin,
  design,
  management,
  marketing,
  popsci;

  String get label => switch (this) {
    PublicationFlow.all => t.filter.all,
    PublicationFlow.develop => t.publication.flow.development,
    PublicationFlow.admin => t.publication.flow.administration,
    PublicationFlow.design => t.publication.flow.design,
    PublicationFlow.management => t.publication.flow.management,
    PublicationFlow.marketing => t.publication.flow.marketing,
    PublicationFlow.popsci => t.publication.flow.popularScience,
  };

  static PublicationFlow fromString(String value) {
    return PublicationFlow.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw const ValueException(.unknownPublicationFlow),
    );
  }
}
