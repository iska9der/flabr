
part of 'publication.dart';

class PublicationLeadImage extends Equatable {
  final String url;
  final String fit;
  final double positionY;
  final double positionX;

  const PublicationLeadImage({
    required this.url,
    this.fit = '',
    this.positionY = 0.00,
    this.positionX = 0.00,
  });

  factory PublicationLeadImage.fromMap(Map<String, dynamic> map) {
    return PublicationLeadImage(
      url: map['url'] as String,
      fit: map['fit'] ?? '',
      positionY:
          map['positionY'] != null
              ? double.parse(map['positionY'].toString())
              : 0.00,
      positionX:
          map['positionX'] != null
              ? double.parse(map['positionX'].toString())
              : 0.00,
    );
  }

  static const empty = PublicationLeadImage(url: '');
  bool get isEmpty => this == empty;

  @override
  List<Object?> get props => [url, fit, positionY, positionX];
}
