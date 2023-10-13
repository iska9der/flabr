import 'dart:convert';

import 'package:equatable/equatable.dart';

class ArticleConfigModel extends Equatable {
  const ArticleConfigModel({
    this.fontScale = 1,
    this.isImagesVisible = true,
    this.webViewEnabled = true,
  });

  final double fontScale;
  final bool isImagesVisible;
  final bool webViewEnabled;

  ArticleConfigModel copyWith({
    double? fontScale,
    bool? isImagesVisible,
    bool? webViewEnabled,
  }) {
    return ArticleConfigModel(
      fontScale: fontScale ?? this.fontScale,
      isImagesVisible: isImagesVisible ?? this.isImagesVisible,
      webViewEnabled: webViewEnabled ?? this.webViewEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontScale': fontScale,
      'isImagesVisible': isImagesVisible,
      'webViewEnabled': webViewEnabled,
    };
  }

  factory ArticleConfigModel.fromMap(Map<String, dynamic> map) {
    return ArticleConfigModel(
      fontScale: map['fontScale'] as double? ?? 1,
      isImagesVisible: map['isImagesVisible'] as bool? ?? true,
      webViewEnabled: map['webViewEnabled'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleConfigModel.fromJson(String source) =>
      ArticleConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = ArticleConfigModel();

  @override
  List<Object> get props => [fontScale, isImagesVisible, webViewEnabled];
}
