import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension CopyableEx on SvgPicture {
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
      pictureProvider,
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
      clipBehavior: clipBehavior ?? this.clipBehavior,
      colorFilter: colorFilter ?? this.colorFilter,
      cacheColorFilter: cacheColorFilter ?? this.cacheColorFilter,
      theme: theme ?? this.theme,
    );
  }
}
