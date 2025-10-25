import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/github_gist.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/app_router.dart';
import '../../../di/di.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../enhancement/progress_indicator.dart';
import 'html_custom_builder.dart';
import 'html_custom_parser.dart';
import 'lazy_code_block.dart';
import 'lazy_webview_block.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.renderMode = RenderMode.sliverList,
    this.padding = const EdgeInsets.only(left: 20, right: 20, bottom: 40),
    this.textStyle = const TextStyle(),
  });

  final String textHtml;
  final RenderMode renderMode;
  final EdgeInsets padding;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final theme = context.theme;
        final publicationConfig = state.publication;
        final isImageVisible = publicationConfig.isImagesVisible;
        final fontScale = publicationConfig.fontScale;
        final fontSize =
            (theme.textTheme.bodyMedium?.fontSize ?? 14) * fontScale;
        final isWebViewEnabled = publicationConfig.webViewEnabled;
        final resultTextStyle = textStyle.copyWith(fontSize: fontSize);

        return HighlightBackgroundEnvironment(
          child: HtmlWidget(
            textHtml,
            renderMode: renderMode,
            textStyle: resultTextStyle,
            rebuildTriggers: [
              theme.brightness,
              fontSize,
              isImageVisible,
              isWebViewEnabled,
            ],
            onErrorBuilder: (_, element, error) =>
                Text('$element error: $error'),
            onLoadingBuilder: (ctx, el, prgrs) =>
                const CircleIndicator.medium(),
            factoryBuilder: () => CustomFactory(context),
            customStylesBuilder: (element) => HtmlCustomStyles.builder(
              element,
              theme,
              padding,
              fontSize,
            ),
            customWidgetBuilder: (element) => HtmlCustomWidget.builder(
              element,
              isImageVisible,
            ),
          ),
        );
      },
    );
  }
}

class CustomFactory extends WidgetFactory with SvgFactory, WebViewFactory {
  CustomFactory(this.context);

  final BuildContext context;

  @override
  bool get webView => true;

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  ThemeData get theme => context.theme;

  /// Переопределяем метод построения SVG изображения
  @override
  Widget? buildImageWidget(BuildTree meta, ImageSource src) {
    Widget? widget = super.buildImageWidget(meta, src);
    if (widget is! SvgPicture) return widget;

    /// переопределяем цвета svg изображений в публикации -
    /// обычно это математические символы/формулы
    widget = widget.copyWith(
      colorFilter: ColorFilter.mode(
        theme.textTheme.bodyMedium!.color!,
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
    Future<void> go() =>
        getIt<AppRouter>().navigateOrLaunchUrl(Uri.parse(href));

    /// Проверяем необходимость открытия модалки
    /// для того чтобы показать полную ссылку на ресурс.
    /// Если текст не совпадает со ссылкой - показываем
    final isNeedPopup = text != href;
    if (!isNeedPopup) {
      return go();
    }

    return context.showAlert(
      compact: true,
      title: Text(
        text,
        maxLines: 1,
        style: context.theme.textTheme.titleSmall?.copyWith(
          overflow: TextOverflow.ellipsis,
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

    /// список кривых iframe-источников
    List<String> banFrameSources = const [],
  }) {
    final isWebViewEnabled = context
        .read<SettingsCubit>()
        .state
        .publication
        .webViewEnabled;

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
  }) {
    final String? lang = attributes['class'];

    final fontSize =
        (context.theme.textTheme.bodySmall?.fontSize ?? 12) *
        context.read<SettingsCubit>().state.publication.fontScale;
    final codeTextStyle = context.theme.textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      fontFamily: HighlightView.defaultFontFamily,
    );
    EdgeInsets padding = const EdgeInsets.all(12);

    final codeTheme = switch (context.theme.brightness) {
      Brightness.dark => darculaTheme,
      Brightness.light => githubGistTheme,
    };

    final bgColor =
        codeTheme['root']?.backgroundColor ??
        context.theme.colors.cardHighlight;

    return BuildOp(
      onRenderBlock: (tree, placeholder) {
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
                constraints: BoxConstraints(
                  minWidth: Device.getWidth(context),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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

          return ColoredBox(
            color: bgColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Device.getWidth(context),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  LazyCodeBlock(
                    text: previewText,
                    language: lang,
                    textStyle: codeTextStyle,
                    maxRows: maxRows,
                    theme: codeTheme,
                    padding: padding,
                    onTap: onTap,
                  ),
                  if (isLong)
                    GestureDetector(
                      onTap: onTap,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 6),
                        child: Text('Показать полностью...'),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return ColoredBox(
          color: bgColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: Device.getWidth(context),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Text(text, style: codeTextStyle),
            ),
          ),
        );
      },
    );
  }
}
