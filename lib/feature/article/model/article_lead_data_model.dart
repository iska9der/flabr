import 'package:equatable/equatable.dart';

import 'article_image_model.dart';

class ArticleLeadDataModel extends Equatable {
  const ArticleLeadDataModel({
    required this.textHtml,
    this.image = ArticleImageModel.empty,
    this.imageUrl = '',
    this.buttonTextHtml = '',
  });

  final String textHtml;
  final ArticleImageModel image;
  final String imageUrl;
  final String buttonTextHtml;

  factory ArticleLeadDataModel.fromMap(Map<String, dynamic> map) {
    return ArticleLeadDataModel(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? ArticleImageModel.fromMap(map['image'])
          : ArticleImageModel.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  static const empty = ArticleLeadDataModel(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
