import 'package:flabr/bloc/error/app_failure.dart';
import 'package:flabr/core/component/router/router.dart';
import 'package:flabr/data/exception/missing_mime_type_exception.dart';
import 'package:flabr/di/di.dart';
import 'package:flabr/feature/image_action/cubit/image_action_cubit.dart';
import 'package:flabr/feature/image_action/model/image_data.dart';
import 'package:flabr/feature/image_action/service/image_loader.dart';
import 'package:flabr/feature/image_action/widget/full_image_widget.dart';
import 'package:flabr/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.ru);
    getIt.registerSingleton<AppRouter>(AppRouter());
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('shows a localized snackbar on image action failure', (
    tester,
  ) async {
    final cubit = _TestImageActionCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<ImageActionCubit>.value(
              value: cubit,
              child: const FullImageBottomBar(),
            ),
          ),
        ),
      ),
    );

    cubit.fail(const MissingMimeTypeException());
    await tester.pumpAndSettle();

    expect(find.text(t.image.missingMimeType), findsOneWidget);
  });
}

final class _TestImageActionCubit extends ImageActionCubit {
  _TestImageActionCubit() : super(loader: _UnusedImageLoader(), url: '');

  void fail(Object error) {
    emit(
      state.copyWith(
        status: ImageActionStatus.failure,
        error: AppFailure(.operationFailed, error),
      ),
    );
  }
}

final class _UnusedImageLoader implements ImageLoader {
  @override
  Future<ImageData> load(String url) => throw UnimplementedError();
}
