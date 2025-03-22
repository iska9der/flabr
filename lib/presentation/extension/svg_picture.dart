import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension SvgPictureX on SvgPicture {
  copyWith({
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    WidgetBuilder? placeholderBuilder,
    bool? matchTextDirection,
    bool? allowDrawingOutsideViewBox,
    String? semanticsLabel,
    bool? excludeFromSemantics,
    Clip? clipBehavior,
    ColorFilter? colorFilter,
    bool? cacheColorFilter,
    SvgTheme? theme,
  }) {
    return SvgPicture(
      bytesLoader,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? this.allowDrawingOutsideViewBox,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      colorFilter: colorFilter ?? this.colorFilter,
    );
  }
}
