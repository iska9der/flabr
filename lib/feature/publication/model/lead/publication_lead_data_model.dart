import 'package:equatable/equatable.dart';

import 'publication_lead_image_model.dart';

class PublicationLeadDataModel extends Equatable {
  const PublicationLeadDataModel({
    required this.textHtml,
    this.image = PublicationLeadImageModel.empty,
    this.imageUrl = '',
    this.buttonTextHtml = '',
  });

  final String textHtml;
  final PublicationLeadImageModel image;
  final String imageUrl;
  final String buttonTextHtml;

  factory PublicationLeadDataModel.fromMap(Map<String, dynamic> map) {
    return PublicationLeadDataModel(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? PublicationLeadImageModel.fromMap(map['image'])
          : PublicationLeadImageModel.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  static const empty = PublicationLeadDataModel(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
