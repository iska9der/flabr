import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '../../../../../feature/image_action/widget/network_image_widget.dart';
import '../../../../extension/context.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/html_view/html_view.dart';

class CardHtmlWidget extends StatelessWidget {
  const CardHtmlWidget({
    super.key,
    required this.textHtml,
    this.rebuildTriggers,
    this.isTextVisible = true,
    this.isImageVisible = true,
  });

  final String textHtml;
  final List<dynamic>? rebuildTriggers;
  final bool isTextVisible;
  final bool isImageVisible;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textStyle = theme.textTheme.bodyLarge!;

    return HtmlWidget(
      textHtml,
      rebuildTriggers: rebuildTriggers,
      textStyle: textStyle,
      customStylesBuilder: (element) => HtmlCustomStyles.builder(
        element,
        theme,
        EdgeInsets.zero,
        textStyle.fontSize!,
      ),
      customWidgetBuilder: (element) {
        return switch (element.localName) {
          'br' => const SizedBox.shrink(),
          'p' => _buildTextWidget(element, isTextVisible),
          'img' => _buildImageWidget(element, isImageVisible),
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
