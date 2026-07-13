import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/github_gist.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import '../../../core/component/router/router.dart';
import '../../../core/constants/constants.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../enhancement/progress_indicator.dart';
import 'html_config.dart';
import 'html_custom_builder.dart';
import 'html_custom_parser.dart';
import 'lazy_code_block.dart';
import 'lazy_webview_block.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.textStyle,
    this.renderMode = .sliverList,
    this.padding = const .only(left: 20, right: 20, bottom: 40),
    this.config = const HtmlConfig(),
  });

  final String textHtml;
  final TextStyle? textStyle;
  final RenderMode renderMode;
  final EdgeInsets padding;
  final HtmlConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final resultTextStyle = textStyle ?? theme.textTheme.bodyMedium!;

    return HtmlWidget(
      textHtml,
      renderMode: renderMode,
      textStyle: resultTextStyle,
      rebuildTriggers: [
        theme.brightness,
        config,
      ],
      onErrorBuilder: (_, element, error) => Text('$element error: $error'),
      onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.medium(),
      factoryBuilder: CustomFactory.new,
      customStylesBuilder: (element) => HtmlCustomStyles.builder(
        element,
        theme,
        padding,
        config,
        fontSize: resultTextStyle.fontSize!,
        headerTextStyle: theme.appTypography.publicationTitle,
      ),
      customWidgetBuilder: (element) =>
          HtmlCustomWidget.builder(element, config),
    );
  }
}

class CustomFactory extends WidgetFactory with SvgFactory, WebViewFactory {
  BuildContext? _context;
  BuildContext get context => _context!;
  ThemeData get theme => context.theme;

  TextStyle? _textStyle;
  TextStyle get textStyle => _textStyle ?? theme.textTheme.bodyMedium!;

  HtmlConfig _config = const HtmlConfig();
  double get fontScale => _config.fontScale;
  bool get isWebViewEnabled => _config.isWebViewVisible;

  @override
  bool get webView => true;

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  @override
  void reset(State state) {
    super.reset(state);

    _context = state.context;

    final widget = state.widget;
    if (widget is! HtmlWidget) {
      return;
    }

    _textStyle = widget.textStyle;
    _config = widget.rebuildTriggers.firstWhere(
      (trigger) => trigger is HtmlConfig,
      orElse: () => _config,
    );
  }

  /// Переопределяем метод построения SVG изображения
  @override
  Widget? buildImageWidget(BuildTree meta, ImageSource src) {
    Widget? widget = super.buildImageWidget(meta, src);
    if (widget is! SvgPicture) return widget;

    /// переопределяем цвета svg изображений в публикации -
    /// обычно это математические символы/формулы
    widget = widget.copyWith(
      colorFilter: ColorFilter.mode(
        textStyle.color ?? theme.textTheme.bodyMedium!.color!,
        BlendMode.srcIn,
      ),
    );

    return widget;
  }

  @override
  void parse(BuildTree meta) {
    final element = meta.element;
    final attributes = element.attributes;

    switch (element.localName) {
      case 'a':
        final op = CustomBuildOp.buildLinkOp(context, this, attributes);
        meta.register(op);
        break;
      case 'div':
        if (!element.className.contains('tm-iframe_temp')) break;

        final op = CustomBuildOp.buildWebViewOp(
          context,
          this,
          attributes,
          isWebViewEnabled: isWebViewEnabled,
          banFrameSources: ['video.yandex.ru/iframe'],
        );
        meta.register(op);
        break;
      case 'code':

        /// если родитель не "pre", то это инлайновый фрагмент кода
        /// добавляем стиль с помощью customStylesBuilder
        if (element.parent?.localName != 'pre') break;

        final op = CustomBuildOp.buildCodeOp(
          context,
          attributes,
          text: element.text,
          fontScale: fontScale,
        );
        meta.register(op);
        break;
    }

    return super.parse(meta);
  }
}

abstract class CustomBuildOp {
  static Future<void> onTap(
    BuildContext context, {
    required String href,
    required String text,
  }) async {
    final uri = Uri.parse(href);

    Future<void> go() => getIt<AppRouter>().navigateOrLaunchUrl(uri);

    /// Проверяем необходимость открытия модалки
    /// для того чтобы показать полную ссылку на ресурс.
    /// Если текст не совпадает со ссылкой - показываем
    final isNeedPopup = !AppEnvironment.isHostSafe(uri) && text != href;
    if (!isNeedPopup) {
      return go();
    }

    return context.showAlert(
      compact: true,
      title: Text(
        text,
        maxLines: 1,
        style: context.theme.textTheme.titleMedium?.copyWith(
          overflow: .ellipsis,
        ),
      ),
      content: SelectableText(href),
      actionsBuilder: (context) => [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: href));
            context.showSnack(
              content: const Text('Скопировано в буфер обмена'),
            );
          },
          child: const Text('Копировать в буфер'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            go();
          },
          child: const Text('Перейти'),
        ),
      ],
    );
  }

  static BuildOp buildLinkOp(
    BuildContext context,
    WidgetFactory factory,
    Map<Object, String> attributes,
  ) {
    return BuildOp.v2(
      alwaysRenderBlock: false,
      debugLabel: 'a-custom[href]',
      priority: 9007199254740991,
      onParsed: (tree) {
        final href = attributes['href'];
        if (href == null) return tree;

        /// anchor links обрабатываются самой библиотекой
        if (href.startsWith('#')) return tree;

        final recognizer = factory.buildGestureRecognizer(
          tree,
          onTap: () => onTap(context, href: href, text: tree.element.text),
        )!;

        if (tree.isInline == true) {
          for (final bit in tree.bits) {
            if (bit is WidgetBit && bit.isInline == false) {
              bit.child.wrapWith(
                (_, child) => factory.buildGestureDetector(
                  tree,
                  child,
                  recognizer,
                ),
              );
            }
          }
        }

        return tree
          ..inherit(
            (resolving, input) =>
                resolving.copyWith<GestureRecognizer>(value: input),
            recognizer,
          )
          ..setNonInherited<GestureRecognizer>(recognizer);
      },
      onRenderBlock: (tree, placeholder) {
        final recognizer = tree.getNonInherited<GestureRecognizer>();
        if (recognizer != null) {
          placeholder.wrapWith((context, child) {
            if (child == widget0) {
              return null;
            }

            // for block A tag: wrap itself in a gesture detector
            return factory.buildGestureDetector(tree, child, recognizer);
          });
        }
        return placeholder;
      },
    );
  }

  static BuildOp buildWebViewOp(
    BuildContext context,
    WebViewFactory factory,
    Map<Object, String> attributes, {
    required bool isWebViewEnabled,

    /// список кривых iframe-источников
    List<String> banFrameSources = const [],
  }) {
    return BuildOp(
      onRenderBlock: (meta, widgets) {
        // Извлекаем высоту с учетом CSS стилей и родительских элементов
        // Ширина всегда 100% (на всю ширину экрана)
        final element = meta.element;
        final src = HtmlCustomParser.extractSource(element);
        final isBanned = banFrameSources.any((b) => src.contains(b));
        final canShow = isWebViewEnabled && !isBanned;

        final width = Device.getWidth(context);
        final height = HtmlCustomParser.extractHeight(element);
        final aspectRatio = height != null ? width / height : 16 / 9;
        final sandbox = element.attributes['sandbox'];

        final widget = LazyWebViewBlock(
          src: src,
          aspectRatio: aspectRatio,
          canShow: canShow,
          buildWebView: () {
            final webView = factory.buildWebView(
              meta,
              src,
              sandbox: sandbox?.split(RegExp(r'\s+')),
            );

            return webView ?? const SizedBox.shrink();
          },
        );

        return widget;
      },
    );
  }

  static BuildOp buildCodeOp(
    BuildContext context,
    LinkedHashMap<Object, String> attributes, {
    required String text,
    required double fontScale,
  }) {
    final theme = context.theme;
    final String? lang = attributes['class'];

    final fontSize = (theme.textTheme.bodySmall?.fontSize ?? 12) * fontScale;
    final codeTextStyle = theme.textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      fontFamily: HighlightView.defaultFontFamily,
    );
    EdgeInsets padding = const .all(12);

    final codeTheme = {
      ...switch (theme.brightness) {
        .dark => darculaTheme,
        .light => githubGistTheme,
      },
    };

    final bgColor = theme.colors.backgroundSecondary;
    codeTheme['root'] = codeTheme['root']!.copyWith(backgroundColor: bgColor);
    final decoration = BoxDecoration(
      color: bgColor,
      border: .all(color: theme.colors.background),
      borderRadius: .circular(4),
    );

    return BuildOp(
      onRenderBlock: (tree, placeholder) {
        final constraints = BoxConstraints(minWidth: Device.getWidth(context));

        if (lang != null) {
          final maxRows = 5;
          final splittedText = text.split('\n');
          final isLong = splittedText.length > maxRows;
          final previewText = isLong
              ? splittedText.getRange(0, 5).join('\n')
              : text;
          final tabSize = 4;

          padding = isLong ? padding.copyWith(bottom: 28) : padding;

          VoidCallback? onTap = switch (isLong) {
            false => null,
            true => () => context.buildModalRoute(
              rootNavigator: true,
              child: ConstrainedBox(
                constraints: constraints,
                child: SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: HighlightView(
                    text,
                    language: lang,
                    tabSize: tabSize,
                    textStyle: codeTextStyle,
                    theme: codeTheme,
                    padding: padding,
                  ),
                ),
              ),
            ),
          };

          return ConstrainedBox(
            constraints: constraints,
            child: Stack(
              alignment: .bottomLeft,
              children: [
                LazyCodeBlock(
                  text: previewText,
                  language: lang,
                  theme: codeTheme,
                  decoration: decoration,
                  textStyle: codeTextStyle,
                  maxRows: maxRows,
                  padding: padding,
                  onTap: onTap,
                ),
                if (isLong)
                  GestureDetector(
                    onTap: onTap,
                    child: Padding(
                      padding: const .only(left: 12, bottom: 6),
                      child: Text(
                        'Показать полностью...',

                        /// Если убрать стиль, то во время hero-анимации
                        /// стиль не подцепится, и будет отображаться debug стиль
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return ConstrainedBox(
          constraints: constraints,
          child: DecoratedBox(
            decoration: decoration,
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              padding: const .all(12),
              child: Text(text, style: codeTextStyle),
            ),
          ),
        );
      },
    );
  }
}
