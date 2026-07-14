import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '../../../../../feature/image_action/widget/network_image_widget.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/html_view/html_view.dart';

class CardHtmlWidget extends StatelessWidget {
  const CardHtmlWidget({
    super.key,
    required this.htmlText,
    this.isTextVisible = true,
    this.isImageVisible = true,
  });

  final String htmlText;
  final bool isTextVisible;
  final bool isImageVisible;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textStyle = theme.appTypography.publicationText;
    final config = HtmlConfig(
      titleStyle: theme.appTypography.publicationTitle,
      isImageVisible: isImageVisible,
      isTextVisible: isTextVisible,
    );

    return HtmlWidget(
      htmlText,
      rebuildTriggers: [config],
      textStyle: textStyle,
      customStylesBuilder: (element) => HtmlCustomStyles.builder(
        element,
        theme,
        EdgeInsets.zero,
        config,
        fontSize: textStyle.fontSize!,
      ),
      customWidgetBuilder: (element) {
        return switch (element.localName) {
          'br' => const SizedBox.shrink(),
          'p' => _buildTextWidget(element, config.isTextVisible),
          'img' => _buildImageWidget(element, config.isImageVisible),
          _ => null,
        };
      },
    );
  }

  Widget? _buildTextWidget(
    dom.Element element,
    bool isTextVisible,
  ) {
    if (!isTextVisible) return const SizedBox();

    return null;
  }

  Widget? _buildImageWidget(
    dom.Element element,
    bool isImageVisible,
  ) {
    if (!isImageVisible) return const SizedBox();

    String imgSrc = HtmlCustomParser.extractSource(element);
    if (imgSrc.isEmpty) return null;

    return Align(
      child: NetworkImageWidget(
        imageUrl: imgSrc,
        height: AppDimensions.imageHeight,
        isTapable: true,
      ),
    );
  }
}
