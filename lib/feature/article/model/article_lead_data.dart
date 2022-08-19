import 'package:equatable/equatable.dart';

import 'article_image.dart';

class ArticleLeadData extends Equatable {
  const ArticleLeadData({
    required this.textHtml,
    this.image = ArticleImage.empty,
    this.imageUrl = '',
    this.buttonTextHtml = '',
  });

  final String textHtml;
  final ArticleImage image;
  final String imageUrl;
  final String buttonTextHtml;

  factory ArticleLeadData.fromMap(Map<String, dynamic> map) {
    return ArticleLeadData(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'] ?? '',
      image: map['image'] != null
          ? ArticleImage.fromMap(map['image'])
          : ArticleImage.empty,
      buttonTextHtml: map['buttonTextHtml'] ?? '',
    );
  }

  static const empty = ArticleLeadData(textHtml: '');

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
