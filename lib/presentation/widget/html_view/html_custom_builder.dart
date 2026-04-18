import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import '../../extension/extension.dart';
import '../../theme/theme.dart';
import 'html_custom_parser.dart';
import 'lazy_image_widget.dart';

abstract class HtmlCustomWidget {
  static Widget? builder(dom.Element element, bool isImageVisible) {
    return switch (element.localName) {
      'img' => HtmlCustomWidget._buildImageWidget(
        element,
        isImageVisible,
      ),
      _ => null,
    };
  }

  /// Построить виджет изображения с учетом видимости и параметров элемента
  ///
  /// Обрабатывает:
  /// - Проверку видимости изображений в настройках
  /// - Фильтрацию иконок и символов которые должны быть инлайн
  /// - Загрузку изображения с правильными параметрами
  /// - Добавление семантических меток и подсказок
  static Widget? _buildImageWidget(
    dom.Element element,
    bool isImageVisible,
  ) {
    final imgSrc = HtmlCustomParser.extractSource(element);
    if (imgSrc.isEmpty) {
      return null;
    }

    /// Не обрабатываем иконки и символы которые должны быть инлайн
    final shouldSkipInlineImage = _shouldSkipInlineImage(element);
    if (shouldSkipInlineImage) {
      return null;
    }

    /// svg обрабатывается с помощью `SvgFactory`
    final isSvgImage = HtmlCustomParser.checkSrcExtension(imgSrc, 'svg');
    if (isSvgImage) {
      return null;
    }

    return LazyImageWidget(
      imageUrl: imgSrc,
      canShow: isImageVisible,
      semanticLabel: HtmlCustomParser.extractImgLabel(element),
      tooltip: HtmlCustomParser.extractImgTooltip(element),
    );
  }

  /// Проверить, нужно ли пропустить инлайн изображение
  ///
  /// Люди верстают статьи по-разному, и иногда ужасно:
  /// https://habr.com/ru/articles/599753/
  /// почти все элементы находятся под одним родителем,
  /// и поэтому, если мы уберем это условие, иконки подзаголовков
  /// будут рендериться на отдельной строке, а по факту нужно инлайн.
  /// Пусть библиотека сама разбирается с такими случаями.
  static bool _shouldSkipInlineImage(dom.Element element) {
    return element.parent != null &&
        element.parent!.children.length > 1 &&
        element.parent!.localName != 'figure' &&
        element.nextElementSibling?.localName != 'br';
  }
}

abstract class HtmlCustomStyles {
  static Map<String, String>? builder(
    dom.Element element,
    ThemeData theme,
    EdgeInsets padding, {
    double fontSize = 14,
    double fontScale = 1,
  }) {
    final attrName = element.localName;

    if (element.parentNode is dom.DocumentFragment ||
        attrName == 'div' && element.parent == null) {
      return {
        'margin-left': '${padding.left}px',
        'margin-right': '${padding.right}px',
        'padding-top': '${padding.top}px',
        'padding-bottom': '${padding.bottom}px',
        'font-size': '${fontSize}px',
      };
    }

    if (attrName == 'code' && element.parent?.localName != 'pre') {
      return {
        'background-color': '#${theme.colors.backgroundSecondary.toHex}',
        'border-radius': '4px',
        'padding': '3px 6px',
        'font-weight': '500',
      };
    }

    final isHeader = switch (attrName) {
      'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6' => true,
      _ => false,
    };
    if (isHeader) {
      return {
        'font-family': AppTypography.fontGeologica,
        'margin-top': switch (attrName) {
          'h1' || 'h2' => '48px',
          _ => '32px',
        },
        'margin-bottom': '0',
      };
    }

    if (attrName == 'ul') {
      if (element.parent?.localName == 'li') {
        return {
          'margin-left': '12px',
          'padding-left': '12px',
          'margin-top': '2px',
          'padding-top': '2px',
        };
      }
      return {
        'margin-left': '12px',
        'padding-left': '12px',
      };
    }

    if (attrName == 'li') {
      return {
        'margin-top': '0',
        'margin-bottom': '6px',
      };
    }
    if (attrName == 'p' && element.parent?.localName == 'li') {
      return {
        'margin-top': '0',
        'margin-bottom': '0',
      };
    }

    if (attrName == 'blockquote') {
      return {
        'border-left': '4px solid #${theme.colors.accentPrimary.toHex}',
        'padding-left': '12px',
        'padding-right': '12px',
        'margin-left': '0',
        'margin-right': '0',
        'margin-bottom': '12px',
      };
    }
    if (attrName == 'p' && element.parent?.localName == 'blockquote') {
      return {
        'padding': '0',
        'margin': '0',
      };
    }

    if (attrName == 'figcaption') {
      final style = theme.textTheme.bodySmall!.apply(fontSizeFactor: fontScale);

      return {
        'font-size': '${style.fontSize}px',
        'color': '#${theme.colors.textSecondary.toHex}',
      };
    }

    return null;
  }
}
