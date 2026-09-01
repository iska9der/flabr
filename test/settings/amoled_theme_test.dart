import 'dart:convert';

import 'package:flabr/bloc/settings/settings_cubit.dart';
import 'package:flabr/core/component/storage/cache_storage.dart';
import 'package:flabr/core/constants/constants.dart';
import 'package:flabr/data/repository/language_repository.dart';
import 'package:flabr/data/repository/settings_repository.dart';
import 'package:flabr/i18n/i18n.dart';
import 'package:flabr/presentation/page/settings/interface_settings_page.dart';
import 'package:flabr/presentation/page/settings/model/config_model.dart';
import 'package:flabr/presentation/theme/app_theme.dart';
import 'package:flabr/presentation/theme/extension/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.ru));

  group('AMOLED theme config', () {
    test('defaults to disabled for an existing stored config', () {
      final config = ThemeConfigModel.fromJson({'mode': 'dark'});

      expect(config.mode, ThemeMode.dark);
      expect(config.isAmoledTheme, isFalse);
    });

    test('persists the preference when the theme mode changes', () async {
      final storage = _MemoryCacheStorage();
      final repository = SettingsRepository(storage: storage);
      final cubit = SettingsCubit(
        repository: repository,
        languageRepository: LanguageRepository(storage: storage),
      );
      addTearDown(cubit.close);

      cubit.changeTheme(ThemeMode.dark);
      cubit.changeAmoledTheme(isEnabled: true);
      cubit.changeTheme(ThemeMode.light);

      expect(cubit.state.theme.isAmoledTheme, isTrue);
      final raw = await storage.read(CacheKeys.themeConfig);
      final restored = ThemeConfigModel.fromJson(jsonDecode(raw!));
      expect(restored.mode, ThemeMode.light);
      expect(restored.isAmoledTheme, isTrue);
    });
  });

  test('AMOLED theme uses black primary surfaces', () {
    final theme = AppTheme.amoled();
    final colors = theme.extension<AppColorsExtension>()!;

    expect(theme.scaffoldBackgroundColor, Colors.black);
    expect(theme.canvasColor, Colors.black);
    expect(theme.colorScheme.surface, Colors.black);
    expect(theme.colorScheme.surfaceContainer, Colors.black);
    expect(colors.background, Colors.black);
    expect(colors.card, const Color(0xFF0D0D0D));
    expect(AppTheme.dark().colorScheme.surface, const Color(0xFF080808));
  });

  test('only AMOLED theme uses subdued interaction colors', () {
    final amoledTheme = AppTheme.amoled();

    expect(
      amoledTheme.splashColor,
      amoledTheme.colorScheme.onSurface.withValues(alpha: .15),
    );
    expect(
      amoledTheme.highlightColor,
      amoledTheme.colorScheme.onSurface.withValues(alpha: .1),
    );

    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      expect(
        theme.splashColor,
        isNot(theme.colorScheme.onSurface.withValues(alpha: .15)),
      );
      expect(
        theme.highlightColor,
        isNot(theme.colorScheme.onSurface.withValues(alpha: .1)),
      );
    }
  });

  const visibilityTestCases = [
    (
      description: 'shows the toggle for an explicit dark theme',
      mode: ThemeMode.dark,
      platformBrightness: Brightness.light,
      isVisible: true,
    ),
    (
      description: 'shows the toggle for a dark system theme',
      mode: ThemeMode.system,
      platformBrightness: Brightness.dark,
      isVisible: true,
    ),
    (
      description: 'hides the toggle for a light system theme',
      mode: ThemeMode.system,
      platformBrightness: Brightness.light,
      isVisible: false,
    ),
    (
      description: 'hides the toggle for an explicit light theme',
      mode: ThemeMode.light,
      platformBrightness: Brightness.dark,
      isVisible: false,
    ),
  ];

  for (final testCase in visibilityTestCases) {
    testWidgets(testCase.description, (tester) async {
      final cubit = await _pumpThemeSettings(
        tester,
        mode: testCase.mode,
        platformBrightness: testCase.platformBrightness,
      );
      addTearDown(cubit.close);

      expect(
        find.text('AMOLED-режим'),
        testCase.isVisible ? findsOneWidget : findsNothing,
      );
    });
  }

  testWidgets('toggle enables AMOLED in settings', (tester) async {
    final cubit = await _pumpThemeSettings(
      tester,
      mode: ThemeMode.dark,
      platformBrightness: Brightness.dark,
    );
    addTearDown(cubit.close);

    await tester.tap(find.text('AMOLED-режим'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(cubit.state.theme.isAmoledTheme, isTrue);
  });
}

Future<SettingsCubit> _pumpThemeSettings(
  WidgetTester tester, {
  required ThemeMode mode,
  required Brightness platformBrightness,
}) async {
  final storage = _MemoryCacheStorage();
  final cubit = SettingsCubit(
    repository: SettingsRepository(storage: storage),
    languageRepository: LanguageRepository(storage: storage),
  );
  cubit.changeTheme(mode);

  await tester.pumpWidget(
    TranslationProvider(
      child: BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: platformBrightness),
            child: const Scaffold(body: UIThemeWidget()),
          ),
        ),
      ),
    ),
  );

  return cubit;
}

final class _MemoryCacheStorage implements CacheStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }
}
