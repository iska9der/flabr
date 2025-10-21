import 'package:html/dom.dart' as dom;
import 'package:path/path.dart' as p;

/// Утилита для HtmlWidget
class HtmlCustomParser {
  HtmlCustomParser._();

  /// Извлечь источник изображения из атрибутов элемента
  static String extractSource(dom.Element element) {
    return element.attributes['data-src'] ?? element.attributes['src'] ?? '';
  }

  static bool checkSrcExtension(String src, String extension) {
    return p.extension(src).toLowerCase() == '.$extension';
  }

  static String? extractImgLabel(dom.Element element) {
    return element.attributes['alt'];
  }

  static String? extractImgTooltip(dom.Element element) {
    return element.attributes['title'];
  }

  /// Извлекает высоту элемента с fallback стратегией:
  /// 1. Атрибут height
  /// 2. CSS style height текущего элемента
  /// 3. CSS style height родительского элемента
  /// 4. Дефолтное значение для iframe
  static double? extractHeight(
    dom.Element element, {
    double? defaultValue,
  }) {
    // 1. Проверяем атрибут height
    final heightAttr = element.attributes['height'];
    if (heightAttr != null && !_isRelativeValue(heightAttr)) {
      final parsed = _parseNumericValue(heightAttr);
      if (parsed != null) return parsed;
    }

    // 2. Парсим CSS style текущего элемента
    final styleHeight = _extractDimensionFromStyle(
      element.attributes['style'],
      'height',
    );
    if (styleHeight != null) return styleHeight;

    // 3. Проверяем родительский элемент
    final parent = element.parent;
    if (parent != null) {
      final parentHeight = _extractDimensionFromStyle(
        parent.attributes['style'],
        'height',
      );
      if (parentHeight != null) return parentHeight;
    }

    // 4. Возвращаем дефолтное значение
    return defaultValue;
  }

  /// Извлекает ширину элемента с fallback стратегией
  static double? extractWidth(
    dom.Element element, {
    double? defaultValue,
  }) {
    // 1. Проверяем атрибут width
    final widthAttr = element.attributes['width'];
    if (widthAttr != null && !_isRelativeValue(widthAttr)) {
      final parsed = _parseNumericValue(widthAttr);
      if (parsed != null) return parsed;
    }

    // 2. Парсим CSS style текущего элемента
    final styleWidth = _extractDimensionFromStyle(
      element.attributes['style'],
      'width',
    );
    if (styleWidth != null) return styleWidth;

    // 3. Проверяем родительский элемент
    final parent = element.parent;
    if (parent != null) {
      final parentWidth = _extractDimensionFromStyle(
        parent.attributes['style'],
        'width',
      );
      if (parentWidth != null) return parentWidth;
    }

    // 4. Возвращаем дефолтное значение
    return defaultValue;
  }

  /// Извлекает числовое значение из CSS style атрибута
  /// Пример: "height: 300px; width: 100%;" → height → 300.0
  static double? _extractDimensionFromStyle(
    String? styleAttr,
    String dimension,
  ) {
    if (styleAttr == null || styleAttr.isEmpty) return null;

    // Паттерн: height: 300px или height:300px или height: 300
    final pattern = RegExp(
      '$dimension\\s*:\\s*([\\d.]+)(?:px)?',
      caseSensitive: false,
    );

    final match = pattern.firstMatch(styleAttr);
    if (match == null) return null;

    return double.tryParse(match.group(1)!);
  }

  /// Парсит числовое значение из строки (удаляет px, %, etc)
  static double? _parseNumericValue(String value) {
    // Убираем единицы измерения и процент
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }

  /// Проверяет является ли значение относительным (%, auto, inherit)
  static bool _isRelativeValue(String? value) {
    if (value == null) return false;

    const relative = ['%', 'auto', 'inherit', 'initial', 'unset'];
    return relative.any((unit) => value.contains(unit));
  }
}
