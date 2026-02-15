part of 'publication.dart';

class PublicationLeadData with EquatableMixin {
  const PublicationLeadData({
    required this.textHtml,
    this.image = PublicationLeadImage.empty,
    this.imageUrl = '',
    this.buttonTextHtml = '',
  });

  final String textHtml;
  final PublicationLeadImage image;
  final String imageUrl;
  final String buttonTextHtml;

  factory PublicationLeadData.fromJson(Map<String, dynamic> map) {
    return PublicationLeadData(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? PublicationLeadImage.fromJson(map['image'])
          : PublicationLeadImage.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'textHtml': textHtml,
    'imageUrl': imageUrl,
    'image': image.toJson(),
    'buttonTextHtml': buttonTextHtml,
  };

  static const empty = PublicationLeadData(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
