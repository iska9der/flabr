import 'dart:convert';

import 'package:equatable/equatable.dart';

class ArticleConfigModel extends Equatable {
  const ArticleConfigModel({
    this.fontScale = 1,
    this.isImagesVisible = true,
  });

  final double fontScale;
  final bool isImagesVisible;

  ArticleConfigModel copyWith({
    double? fontScale,
    bool? isImagesVisible,
  }) {
    return ArticleConfigModel(
      fontScale: fontScale ?? this.fontScale,
      isImagesVisible: isImagesVisible ?? this.isImagesVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontScale': fontScale,
      'isImagesVisible': isImagesVisible,
    };
  }

  factory ArticleConfigModel.fromMap(Map<String, dynamic> map) {
    return ArticleConfigModel(
      fontScale: map['fontScale'] as double,
      isImagesVisible: map['isImagesVisible'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleConfigModel.fromJson(String source) =>
      ArticleConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = ArticleConfigModel();

  @override
  List<Object> get props => [fontScale, isImagesVisible];
}
