import 'package:equatable/equatable.dart';

import '../../article/model/article_image_model.dart';

class PublicationLeadDataModel extends Equatable {
  const PublicationLeadDataModel({
    required this.textHtml,
    this.image = ArticleImageModel.empty,
    this.imageUrl = '',
    this.buttonTextHtml = '',
  });

  final String textHtml;
  final ArticleImageModel image;
  final String imageUrl;
  final String buttonTextHtml;

  factory PublicationLeadDataModel.fromMap(Map<String, dynamic> map) {
    return PublicationLeadDataModel(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? ArticleImageModel.fromMap(map['image'])
          : ArticleImageModel.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  static const empty = PublicationLeadDataModel(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
