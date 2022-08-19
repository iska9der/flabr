import 'package:equatable/equatable.dart';

class ArticleImage extends Equatable {
  final String url;
  final String fit;
  final double positionY;
  final double positionX;

  const ArticleImage({
    required this.url,
    this.fit = '',
    this.positionY = 0.00,
    this.positionX = 0.00,
  });

  factory ArticleImage.fromMap(Map<String, dynamic> map) {
    return ArticleImage(
      url: map['url'] as String,
      fit: map['fit'] ?? '',
      positionY: map['positionY'] != null
          ? double.parse(map['positionY'].toString())
          : 0.00,
      positionX: map['positionX'] != null
          ? double.parse(map['positionX'].toString())
          : 0.00,
    );
  }

  static const empty = ArticleImage(url: '');

  get isNotEmpty => this != empty;

  @override
  List<Object?> get props => [url, fit, positionY, positionX];
}
