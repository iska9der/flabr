import 'package:equatable/equatable.dart';

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    required this.titleHtml,
    required this.timePublished,
    required this.leadData,
  });

  final String id;
  final String titleHtml;
  final DateTime timePublished;
  final LeadData leadData;

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] as String,
      titleHtml: map['titleHtml'] as String,
      timePublished: DateTime.parse(map['timePublished']),
      leadData: LeadData.fromMap(map['leadData']),
    );
  }

  @override
  List<Object> get props => [id, titleHtml, timePublished, leadData];
}

class LeadData extends Equatable {
  const LeadData({
    required this.textHtml,
    this.imageUrl,
    this.image,
    this.buttonTextHtml,
  });

  final String textHtml;
  final String? imageUrl;
  final ArticleImage? image;
  final String? buttonTextHtml;

  factory LeadData.fromMap(Map<String, dynamic> map) {
    return LeadData(
      textHtml: map['textHtml'],
      imageUrl: map['imageUrl'],
      image: map['image'] != null ? ArticleImage.fromMap(map['image']) : null,
      buttonTextHtml: map['buttonTextHtml'],
    );
  }

  @override
  List<Object?> get props => [textHtml, imageUrl, image, buttonTextHtml];
}

class ArticleImage extends Equatable {
  final String url;
  final String? fit;
  final int? positionY;
  final int? positionX;

  const ArticleImage({
    required this.url,
    this.fit,
    required this.positionY,
    required this.positionX,
  });

  factory ArticleImage.fromMap(Map<String, dynamic> map) {
    return ArticleImage(
      url: map['url'] as String,
      fit: map['fit'],
      positionY: map['positionY'],
      positionX: map['positionX'],
    );
  }

  @override
  List<Object?> get props => [url, fit, positionY, positionX];
}
