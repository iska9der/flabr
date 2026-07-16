import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HtmlConfig with Equatable {
  const HtmlConfig({
    this.fontScale = 1.0,
    this.isTextVisible = true,
    this.isImageVisible = true,
    this.isWebViewVisible = true,
    this.titleStyle,
  });

  final double fontScale;
  final bool isTextVisible;
  final bool isImageVisible;
  final bool isWebViewVisible;
  final TextStyle? titleStyle;

  @override
  List<Object?> get props => [
    fontScale,
    isTextVisible,
    isImageVisible,
    isWebViewVisible,
    titleStyle,
  ];
}
