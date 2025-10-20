import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import '../../../feature/image_action/image_action.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import 'html_custom_parser.dart';

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
    /// Если пользователь не хочет видеть изображения - не показываем
    if (!isImageVisible) return const SizedBox.shrink();

    /// Не обрабатываем иконки и символы которые должны быть инлайн
    final shouldSkipInlineImage = _shouldSkipInlineImage(element);
    if (shouldSkipInlineImage) return null;

    final imgSrc = HtmlCustomParser.extractSource(element);
    if (imgSrc.isEmpty) return null;

    /// svg обрабатывается с помощью `SvgFactory`
    final isSvgImage = HtmlCustomParser.checkSrcExtension(imgSrc, 'svg');
    if (isSvgImage) return null;

    return _wrapImageWithMetadata(
      NetworkImageWidget(
        imageUrl: imgSrc,
        height: AppDimensions.imageHeight,
        isTapable: true,
      ),
      element,
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

  /// Обернуть изображение в семантику и подсказки
  static Widget _wrapImageWithMetadata(
    Widget imageWidget,
    dom.Element element,
  ) {
    Widget result = imageWidget;

    /// Добавить семантическую метку если доступна
    final semanticLabel =
        element.attributes['alt'] ?? element.attributes['title'];
    if (semanticLabel != null) {
      result = Semantics(
        label: semanticLabel,
        image: true,
        child: result,
      );
    }

    /// Добавить подсказку (tooltip) если доступна
    final tooltip = element.attributes['title'];
    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    /// Выравнять изображение по центру
    result = Align(child: result);

    return result;
  }
}

abstract class HtmlCustomStyles {
  static Map<String, String>? builder(
    dom.Element element,
    ThemeData theme,
    EdgeInsets padding,
    double fontSize,
  ) {
    if (element.localName == 'div' && element.parent == null) {
      return {
        'margin-left': '${padding.left}px',
        'margin-right': '${padding.right}px',
        'padding-bottom': '${padding.bottom}px',
        'font-size': '${fontSize}px',
      };
    }

    if (element.localName == 'code' && element.parent?.localName != 'pre') {
      return {
        'background-color': theme.colors.cardHighlight.toHex,
        'font-weight': '500',
      };
    }

    final headerWeight = switch (element.localName) {
      'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6' => '700',
      _ => '',
    };
    if (headerWeight.isNotEmpty) {
      return {
        'font-family': 'Geologica',
        'font-weight': headerWeight,
      };
    }

    if (element.localName == 'li') {
      return {'margin-bottom': '6px'};
    }

    return null;
  }
}
