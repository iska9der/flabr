import 'package:equatable/equatable.dart';

import 'publication_lead_image_model.dart';

class PublicationLeadData extends Equatable {
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

  factory PublicationLeadData.fromMap(Map<String, dynamic> map) {
    return PublicationLeadData(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? PublicationLeadImage.fromMap(map['image'])
          : PublicationLeadImage.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  static const empty = PublicationLeadData(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
