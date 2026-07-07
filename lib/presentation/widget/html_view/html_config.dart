import 'package:equatable/equatable.dart';

class HtmlConfig with EquatableMixin {
  const HtmlConfig({
    this.fontScale = 1.0,
    this.isImageVisible = true,
    this.isWebViewVisible = true,
  });

  final double fontScale;
  final bool isImageVisible;
  final bool isWebViewVisible;

  @override
  List<Object?> get props => [
    fontScale,
    isImageVisible,
    isWebViewVisible,
  ];
}
