import 'package:flutter/material.dart';

import 'lazy_visibility_widget.dart';

/// Ленивый рендеринг WebView блока
///
/// Показывает placeholder до попадания в viewport.
/// После видимости инициализирует полноценный WebView.
class LazyWebViewBlock extends StatelessWidget {
  const LazyWebViewBlock({
    super.key,
    required this.src,
    required this.buildWebView,
    required this.placeholder,
  });

  final String src;
  final Widget Function() buildWebView;
  final Widget Function() placeholder;

  @override
  Widget build(BuildContext context) {
    return LazyVisibilityWidget(
      uniqueKey: 'webview-${src.hashCode}',
      debounceDelay: const Duration(milliseconds: 300),
      // Сбрасываем состояние если URL изменился
      resetKey: src,
      placeholder: placeholder,
      content: () => buildWebView(),
    );
  }
}
