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
    PublicationFlow.develop => t.publication.flowDevelopment,
    PublicationFlow.admin => t.publication.flowAdministration,
    PublicationFlow.design => t.publication.flowDesign,
    PublicationFlow.management => t.publication.flowManagement,
    PublicationFlow.marketing => t.publication.flowMarketing,
    PublicationFlow.popsci => t.publication.flowPopularScience,
  };

  static PublicationFlow fromString(String value) {
    return PublicationFlow.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw const ValueException(.unknownPublicationFlow),
    );
  }
}
