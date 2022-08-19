import 'package:equatable/equatable.dart';

import 'article_image.dart';

class ArticleLeadData extends Equatable {
  const ArticleLeadData({
    required this.textHtml,
    this.imageUrl,
    this.image,
    this.buttonTextHtml,
  });

  final String textHtml;
  final String? imageUrl;
  final ArticleImage? image;
  final String? buttonTextHtml;

  factory ArticleLeadData.fromMap(Map<String, dynamic> map) {
    return ArticleLeadData(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'],
      image: map['image'] != null ? ArticleImage.fromMap(map['image']) : null,
      buttonTextHtml: map['buttonTextHtml'],
    );
  }

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}
