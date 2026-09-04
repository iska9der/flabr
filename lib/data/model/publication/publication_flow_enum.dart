part of 'publication.dart';

/// Поток публикаций с alias, используемым API и маршрутами Хабра
enum PublicationFlow {
  all('all'),
  backend('backend'),
  frontend('frontend'),
  mobileDevelopment('mobile_development'),
  gameDevelopment('gamedev'),
  qualityAssurance('quality_assurance'),
  aiAndMl('ai_and_ml'),
  industrialEngineering('industrial_engineering'),
  admin('admin'),
  informationSecurity('information_security'),
  analytics('analytics'),
  support('support'),
  management('management'),
  topManagement('top_management'),
  humanResources('human_resources'),
  design('design'),
  marketing('marketing'),
  hardwareAndGadgets('hardware_and_gadgets'),
  diy('diy'),
  popsci('popsci'),
  healthcare('healthcare');

  const PublicationFlow(this.alias);

  /// Alias потока в API и URL Хабра
  final String alias;

  String get label => switch (this) {
    PublicationFlow.all => t.filter.all,
    PublicationFlow.backend => t.publication.flow.backend,
    PublicationFlow.frontend => t.publication.flow.frontend,
    PublicationFlow.mobileDevelopment => t.publication.flow.mobileDevelopment,
    PublicationFlow.gameDevelopment => t.publication.flow.gameDevelopment,
    PublicationFlow.qualityAssurance => t.publication.flow.qualityAssurance,
    PublicationFlow.aiAndMl => t.publication.flow.aiAndMl,
    PublicationFlow.industrialEngineering =>
      t.publication.flow.industrialEngineering,
    PublicationFlow.admin => t.publication.flow.administration,
    PublicationFlow.informationSecurity =>
      t.publication.flow.informationSecurity,
    PublicationFlow.analytics => t.publication.flow.analytics,
    PublicationFlow.support => t.publication.flow.support,
    PublicationFlow.management => t.publication.flow.management,
    PublicationFlow.topManagement => t.publication.flow.topManagement,
    PublicationFlow.humanResources => t.publication.flow.humanResources,
    PublicationFlow.design => t.publication.flow.design,
    PublicationFlow.marketing => t.publication.flow.marketing,
    PublicationFlow.hardwareAndGadgets => t.publication.flow.hardwareAndGadgets,
    PublicationFlow.diy => t.publication.flow.diy,
    PublicationFlow.popsci => t.publication.flow.popularScience,
    PublicationFlow.healthcare => t.publication.flow.healthcare,
  };

  static PublicationFlow fromString(String value) {
    return PublicationFlow.values.firstWhere(
      (e) => e.alias == value,
      orElse: () => throw const ValueException(.unknownPublicationFlow),
    );
  }
}

/// Раздел потоков в порядке основного меню Хабра
enum PublicationFlowGroup {
  developmentAndEngineering,
  infrastructureAndData,
  management,
  creativeAndPromotion,
  scienceAndLife;

  String get label => switch (this) {
    PublicationFlowGroup.developmentAndEngineering =>
      t.publication.flow.group.developmentAndEngineering,
    PublicationFlowGroup.infrastructureAndData =>
      t.publication.flow.group.infrastructureAndData,
    PublicationFlowGroup.management => t.publication.flow.group.management,
    PublicationFlowGroup.creativeAndPromotion =>
      t.publication.flow.group.creativeAndPromotion,
    PublicationFlowGroup.scienceAndLife =>
      t.publication.flow.group.scienceAndLife,
  };

  /// Потоки в порядке меню Хабра
  List<PublicationFlow> get flows => switch (this) {
    PublicationFlowGroup.developmentAndEngineering => const [
      PublicationFlow.backend,
      PublicationFlow.frontend,
      PublicationFlow.mobileDevelopment,
      PublicationFlow.gameDevelopment,
      PublicationFlow.qualityAssurance,
      PublicationFlow.aiAndMl,
      PublicationFlow.industrialEngineering,
    ],
    PublicationFlowGroup.infrastructureAndData => const [
      PublicationFlow.admin,
      PublicationFlow.informationSecurity,
      PublicationFlow.analytics,
      PublicationFlow.support,
    ],
    PublicationFlowGroup.management => const [
      PublicationFlow.management,
      PublicationFlow.topManagement,
      PublicationFlow.humanResources,
    ],
    PublicationFlowGroup.creativeAndPromotion => const [
      PublicationFlow.design,
      PublicationFlow.marketing,
    ],
    PublicationFlowGroup.scienceAndLife => const [
      PublicationFlow.hardwareAndGadgets,
      PublicationFlow.diy,
      PublicationFlow.popsci,
      PublicationFlow.healthcare,
    ],
  };
}
