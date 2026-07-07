import 'package:flutter/material.dart';

class HtmlConfig {
  const HtmlConfig({
    this.textStyle,
    this.fontScale = 1.0,
    this.isImageVisible = true,
    this.isWebViewVisible = true,
  });

  final TextStyle? textStyle;
  final double fontScale;
  final bool isImageVisible;
  final bool isWebViewVisible;
}
