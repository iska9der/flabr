import 'dart:convert';

import 'package:equatable/equatable.dart';

class PublicationConfigModel extends Equatable {
  const PublicationConfigModel({
    this.fontScale = 1,
    this.isImagesVisible = true,
    this.webViewEnabled = true,
  });

  final double fontScale;
  final bool isImagesVisible;
  final bool webViewEnabled;

  PublicationConfigModel copyWith({
    double? fontScale,
    bool? isImagesVisible,
    bool? webViewEnabled,
  }) {
    return PublicationConfigModel(
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

  factory PublicationConfigModel.fromMap(Map<String, dynamic> map) {
    return PublicationConfigModel(
      fontScale: map['fontScale'] as double? ?? 1,
      isImagesVisible: map['isImagesVisible'] as bool? ?? true,
      webViewEnabled: map['webViewEnabled'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory PublicationConfigModel.fromJson(String source) =>
      PublicationConfigModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  static const empty = PublicationConfigModel();

  @override
  List<Object> get props => [fontScale, isImagesVisible, webViewEnabled];
}
