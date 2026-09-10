import 'package:device_preview/device_preview.dart';
import 'package:flabr/bloc/auth/auth_cubit.dart';
import 'package:flabr/bloc/publication/feed_publication_list_cubit.dart';
import 'package:flabr/bloc/publication/flow_publication_list_cubit.dart';
import 'package:flabr/bloc/publication/publication_detail_cubit.dart';
import 'package:flabr/bloc/settings/settings_cubit.dart';
import 'package:flabr/data/demo/demo_publications.dart';
import 'package:flabr/data/model/language/language.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flabr/data/repository/language_repository.dart';
import 'package:flabr/di/di.dart';
import 'package:flabr/feature/image_action/widget/network_image_widget.dart';
import 'package:flabr/i18n/i18n.dart';
import 'package:flabr/presentation/app.dart';
import 'package:flabr/presentation/page/publications/feed/feed_list_page.dart';
import 'package:flabr/presentation/page/publications/news/news_list_page.dart';
import 'package:flabr/presentation/page/publications/widget/card/card_html_widget.dart';
import 'package:flabr/presentation/page/publications/widget/card/common_card_widget.dart';
import 'package:flabr/presentation/page/publications/widget/card/components/dbg_info_widget.dart';
import 'package:flabr/presentation/page/publications/widget/publication_detail_view.dart';
import 'package:flabr/presentation/page/publications/widget/publication_filters_widget.dart';
import 'package:flabr/presentation/page/settings/feed_settings_page.dart';
import 'package:flabr/presentation/page/settings/interface_settings_page.dart';
import 'package:flabr/presentation/page/settings/settings_page.dart';
import 'package:flabr/presentation/widget/html_view/lazy_image_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' as html;
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import 'screenshot_config.dart';

class ScreenshotCapture {
  ScreenshotCapture(this.tester, this.binding);

  final WidgetTester tester;
  final IntegrationTestWidgetsFlutterBinding binding;
  final Set<String> names = {};
  late Language _language;
  PublicationCommon? _readerArticle;

  SettingsState get _settings => getIt<SettingsCubit>().state;

  Future<void> waitForApplication() async {
    await _waitFor(
      () => find.byType(NavigationBar).hitTestable().evaluate().isNotEmpty,
      'Application navigation',
    );
    expect(
      tester
          .element(find.byType(ApplicationView))
          .read<AuthCubit>()
          .state
          .isUnauthorized,
      isTrue,
      reason: 'The dedicated demo installation must start without an account',
    );
    expect(find.byType(DevicePreview), findsNothing);
    expect(find.byType(DbgInfoWidget), findsNothing);
  }

  Future<void> configureLanguage(String code) async {
    _language = Language.fromString(code);
    await _dismissTransientSurface();
    _readerArticle = null;
    await _openInterface();
    await _interfaceToTop();
    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    await _revealInterface(find.byType(UILangWidget));
    final uiChoice = find.descendant(
      of: find.byType(UILangWidget),
      matching: find.text(_language.label),
    );
    await tester.tap(uiChoice);
    await _waitFor(() => _settings.langUI == _language, 'UI language $code');
    await tester.pumpAndSettle();

    await _interfaceToTop();
    await _enableShortDescriptions();
    _assertSettings();
  }

  Future<void> show(ScreenshotScreen screen) async {
    await _dismissTransientSurface();
    switch (screen) {
      case ScreenshotScreen.feed:
        await _prepareFeed();
        await _waitForFeedDescription();
        await _waitForImages();
      case ScreenshotScreen.newsFilters:
        await _tapBottomTab(Icons.article_rounded);
        await _tapPublicationTab(t.publication.dashboard.news);
        await _refreshList(feed: false);
        await _waitForList(feed: false);
        await _waitForImages();
        await tester.tap(find.byIcon(Icons.filter_list_rounded).hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(PublicationFiltersWidget), findsOneWidget);
        expect(
          find.byKey(const ValueKey('publication-flow-expand')),
          findsOneWidget,
        );
        expect(find.text(t.publication.flow.expand), findsOneWidget);
      case ScreenshotScreen.reader:
        await _prepareFeed();
        final readerArticle = _readerArticle!;
        final articleCard = find.byWidgetPredicate(
          (widget) =>
              widget is CommonCardWidget &&
              widget.publication.id == readerArticle.id,
        );
        final title = find.descendant(
          of: articleCard,
          matching: find.text(readerArticle.titleHtml),
        );
        await tester.ensureVisible(title);
        await tester.tap(title);
        await _waitFor(() {
          final view = find.byType(PublicationDetailView);
          return view.evaluate().isNotEmpty &&
              tester
                      .element(view)
                      .read<PublicationDetailCubit>()
                      .state
                      .status ==
                  .success;
        }, 'Loaded publication reader');
        final detail = tester
            .element(find.byType(PublicationDetailView))
            .read<PublicationDetailCubit>()
            .state
            .publication;
        expect(detail.id, readerArticle.id);
        expect(detail.textHtml, readerArticle.textHtml);
        expect(detail.textHtml, isNotEmpty);
        _assertPublications([detail]);
        await tester.pumpAndSettle();
        final readerScroll = find
            .descendant(
              of: find.byType(PublicationDetailView),
              matching: find.byType(Scrollable),
            )
            .first;
        final position = tester.state<ScrollableState>(readerScroll).position;
        expect(position.pixels, closeTo(position.minScrollExtent, 1));
        await _waitForImages();
      case ScreenshotScreen.interfaceSettings:
        await _openInterface();
        await _interfaceToTop();
        expect(find.byType(UIThemeWidget), findsOneWidget);
    }
  }

  Future<void> capture(String name) async {
    expect(configuredScreenshotNames, contains(name));
    expect(names.add(name), isTrue, reason: 'Each screen is captured once');
    _assertSettings();
    expect(find.byType(DevicePreview), findsNothing);
    expect(find.byType(DbgInfoWidget), findsNothing);
    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  Future<void> _prepareFeed() async {
    await _tapBottomTab(Icons.article_rounded);
    await _tapPublicationTab(t.publication.dashboard.myFeed);
    await _refreshList(feed: true);
    await _waitForList(feed: true);
    _readerArticle = tester
        .widgetList<CommonCardWidget>(find.byType(CommonCardWidget))
        .map((card) => card.publication)
        .firstWhere(
          (publication) => publication.type == PublicationType.article,
        );
    expect(
      _readerArticle!.id,
      _language == Language.en ? '593741' : '335382',
    );
  }

  Future<void> _dismissTransientSurface() async {
    if (find.byType(PublicationFiltersWidget).evaluate().isNotEmpty) {
      await binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
    if (find.byType(PublicationDetailView).evaluate().isNotEmpty) {
      await binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
  }

  Future<void> _openInterface() async {
    if (find.byType(InterfaceSettingsView).evaluate().isNotEmpty) return;
    await _tapBottomTab(Icons.settings_rounded);
    if (find.byType(InterfaceSettingsView).evaluate().isEmpty) {
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();
    }
    expect(find.byType(InterfaceSettingsView), findsOneWidget);
  }

  Future<void> _enableShortDescriptions() async {
    if (_settings.feed.isDescriptionVisible) return;
    await binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);
    final rootScroll = find
        .descendant(
          of: find.byType(SettingsView),
          matching: find.byType(Scrollable),
        )
        .first;
    final feedMenu = find.byIcon(Icons.view_agenda_outlined);
    await tester.scrollUntilVisible(feedMenu, 180, scrollable: rootScroll);
    await tester.tap(feedMenu);
    await tester.pumpAndSettle();
    expect(find.byType(FeedSettingsView), findsOneWidget);
    final description = find.descendant(
      of: find.byType(SettingsFeedWidget),
      matching: find.text(t.settings.feed.cards.shortDescription),
    );
    await tester.scrollUntilVisible(
      description,
      180,
      scrollable: find
          .descendant(
            of: find.byType(FeedSettingsView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(description);
    await _waitFor(
      () => _settings.feed.isDescriptionVisible,
      'Short publication descriptions enabled through Settings',
    );
    await binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);
    final interfaceMenu = find.byIcon(Icons.tune_rounded);
    await tester.scrollUntilVisible(
      interfaceMenu,
      -180,
      scrollable: rootScroll,
    );
    await tester.tap(interfaceMenu);
    await tester.pumpAndSettle();
    await _interfaceToTop();
  }

  Finder get _interfaceScroll => find
      .descendant(
        of: find.byType(InterfaceSettingsView),
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> _revealInterface(Finder control) async {
    await tester.scrollUntilVisible(
      control,
      260,
      scrollable: _interfaceScroll,
      maxScrolls: 15,
    );
    await tester.pumpAndSettle();
  }

  Future<void> _interfaceToTop() async {
    /// Обратный свайп возвращает и заголовок, и скрывшуюся нижнюю навигацию
    for (var attempt = 0; attempt < 15; attempt++) {
      final position = tester.state<ScrollableState>(_interfaceScroll).position;
      if (position.pixels <= position.minScrollExtent + 1) break;
      await tester.drag(_interfaceScroll, const Offset(0, 500));
      await tester.pumpAndSettle();
    }
    expect(
      tester.state<ScrollableState>(_interfaceScroll).position.pixels,
      closeTo(0, 1),
    );
    await tester.pumpAndSettle();
  }

  Future<void> _tapBottomTab(IconData icon) async {
    final target = find
        .descendant(
          of: find.byType(NavigationBar),
          matching: find.byIcon(icon),
        )
        .hitTestable();
    await _waitFor(() => target.evaluate().isNotEmpty, 'Visible bottom tab');
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> _tapPublicationTab(String label) async {
    final target = find.descendant(
      of: find.byType(TabBar),
      matching: find.text(label),
    );
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> _refreshList({required bool feed}) async {
    final scroll = find
        .descendant(
          of: find.byType(feed ? FeedListPage : NewsListPage),
          matching: find.byType(Scrollable),
        )
        .first;
    await _waitFor(
      () => scroll.evaluate().isNotEmpty,
      'Publication list scroll',
    );
    final position = tester.state<ScrollableState>(scroll).position;
    if (position.pixels > position.minScrollExtent + 1) {
      await tester.drag(
        scroll,
        Offset(0, position.pixels - position.minScrollExtent),
        touchSlopY: 0,
      );
      await tester.pumpAndSettle();
    }
    expect(position.pixels, closeTo(position.minScrollExtent, 1));
    await tester.drag(scroll, const Offset(0, 500));
    await tester.pumpAndSettle();

    /// Полоса прокрутки исчезает по idle-таймеру, который не ждёт pumpAndSettle
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  Future<void> _waitForList({required bool feed}) async {
    final page = find.byType(feed ? FeedListPage : NewsListPage);
    final cards = find.descendant(
      of: page,
      matching: find.byType(CommonCardWidget),
    );
    await _waitFor(() {
      if (cards.evaluate().isEmpty) return false;
      final context = tester.element(cards.first);
      return feed
          ? context.read<FeedPublicationListCubit>().state.status == .success
          : context.read<FlowPublicationListCubit>().state.status == .success;
    }, feed ? 'Loaded My Feed' : 'Loaded News');
    final context = tester.element(cards.first);
    final publications = feed
        ? context.read<FeedPublicationListCubit>().state.response.refs
        : context.read<FlowPublicationListCubit>().state.response.refs;
    _assertPublications(publications);
  }

  Future<void> _waitForFeedDescription() async {
    final readerArticle = _readerArticle!;
    final card = find.byWidgetPredicate(
      (widget) =>
          widget is CommonCardWidget &&
          widget.publication.id == readerArticle.id,
    );
    final lead = find.descendant(
      of: card,
      matching: find.byType(CardHtmlWidget),
    );
    final leadHtml = html.parseFragment(readerArticle.leadData.textHtml);
    final excerpt = leadHtml
        .querySelectorAll('p')
        .map((paragraph) => paragraph.text.trim())
        .firstWhere((text) => text.isNotEmpty);
    final description = find.descendant(
      of: lead,
      matching: find.textContaining(excerpt, findRichText: true),
    );
    await _waitFor(
      () =>
          description.hitTestable().evaluate().isNotEmpty &&
          _onScreen(description.first),
      'Rendered My Feed short description',
    );
    final imageUrl = readerArticle.leadData.image.isEmpty
        ? leadHtml.querySelector('img')?.attributes['src']
        : readerArticle.leadData.image.url;
    expect(imageUrl, isNotNull);
    expect(imageUrl, isNotEmpty);
    final illustration = find.descendant(
      of: card,
      matching: find.byWidgetPredicate(
        (widget) => widget is NetworkImageWidget && widget.imageUrl == imageUrl,
      ),
    );
    expect(illustration, findsOneWidget);
    expect(_onScreen(illustration), isTrue);
  }

  void _assertSettings() {
    expect(_settings.langUI, _language);
    expect(getIt<LanguageRepository>().lastUI, _language);
    expect(_settings.theme.mode, ThemeMode.dark);
    expect(_settings.feed.isDescriptionVisible, isTrue);
    final context = tester.element(find.byType(Navigator).last);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(Localizations.localeOf(context).languageCode, _language.name);
  }

  void _assertPublications(Iterable<Publication> publications) {
    expect(publications, isNotEmpty);
    final localized = {
      for (final entry in demoPublications)
        if (entry.language == _language)
          entry.publication.id: entry.publication,
    };
    for (final publication in publications) {
      expect(localized, contains(publication.id));
      final expected = localized[publication.id]!;
      expect(publication, isA<PublicationCommon>());
      expect((publication as PublicationCommon).titleHtml, expected.titleHtml);
      expect(publication.textHtml, expected.textHtml);
      expect(publication.textHtml, isNotEmpty);
    }
  }

  bool _onScreen(Finder finder) {
    final rect = tester.getRect(finder);
    final viewport =
        Offset.zero & (tester.view.physicalSize / tester.view.devicePixelRatio);
    final visible = rect.intersect(viewport);
    return rect.width > 0 &&
        rect.height > 0 &&
        visible.width > 0 &&
        visible.height > 0 &&
        visible.width * visible.height / (rect.width * rect.height) > .1;
  }

  Future<void> _waitForImages() async {
    /// pumpAndSettle не ждёт debounce VisibilityDetector и декодирование ImageStream
    await _waitFor(() {
      for (final element in find.byType(LazyImageWidget).evaluate()) {
        final lazy = find.byWidget(element.widget);
        if (!_onScreen(lazy)) continue;
        final content = find.descendant(
          of: lazy,
          matching: find.byType(NetworkImageWidget),
        );
        if (content.evaluate().isEmpty) return false;
        final fades = tester.widgetList<FadeTransition>(
          find.descendant(
            of: lazy,
            matching: find.byType(FadeTransition),
          ),
        );
        if (fades.isEmpty || fades.any((fade) => fade.opacity.value < 1)) {
          return false;
        }
      }
      for (final element in find.byType(NetworkImageWidget).evaluate()) {
        final image = find.byWidget(element.widget);
        if (!_onScreen(image)) continue;
        final decoded = tester.widgetList<RawImage>(
          find.descendant(
            of: image,
            matching: find.byType(RawImage),
          ),
        );
        if (decoded.isEmpty || decoded.any((raw) => raw.image == null)) {
          return false;
        }
      }
      return true;
    }, 'Visible illustrations decoded and fully opaque');
    await tester.pumpAndSettle();
  }

  Future<void> _waitFor(bool Function() ready, String description) async {
    final timer = Stopwatch()..start();
    while (!ready()) {
      if (timer.elapsed > const Duration(seconds: 20)) {
        fail('Timed out waiting for $description');
      }
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump();
  }
}
