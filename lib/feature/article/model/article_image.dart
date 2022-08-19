import 'package:equatable/equatable.dart';

class ArticleImage extends Equatable {
  final String url;
  final String? fit;
  final double? positionY;
  final double? positionX;

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
      positionY: map['positionY'] != null
          ? double.parse(map['positionY'].toString())
          : null,
      positionX: map['positionX'] != null
          ? double.parse(map['positionX'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [url, fit, positionY, positionX];
}
