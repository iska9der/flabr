part of 'publication.dart';

class PublicationHub extends HubBase with EquatableMixin {
  const PublicationHub({
    required this.id,
    super.alias = '',
    this.title = '',
    this.type = HubType.collective,
    super.isProfiled = false,
    HubRelatedData super.relatedData = HubRelatedData.empty,
  });

  final String id;
  final String title;
  final HubType type;

  @override
  factory PublicationHub.fromJson(Map<String, dynamic> map) {
    return PublicationHub(
      id: map['id'],
      alias: map['alias'] as String,
      title: map['title'] as String,
      type: HubType.fromString((map['type'] ?? 'collective')),
      isProfiled: map['isProfiled'] as bool,
      relatedData: map['relatedData'] != null
          ? HubRelatedData.fromJson(map['relatedData'])
          : HubRelatedData.empty,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'alias': alias,
    'title': title,
    'type': type.name,
    'isProfiled': isProfiled,
    'relatedData': relatedData.toJson(),
  };

  static const empty = PublicationHub(id: '0', title: 'Empty Hub');

  @override
  List<Object?> get props => [
    id,
    alias,
    title,
    type,
    relatedData,
    isProfiled,
    titleHtml,
    imageUrl,
    descriptionHtml,
    isOfftop,
    statistics,
    commonTags,
  ];
}
