part of 'splash.dart';

/// Splash screen с анимированным логотипом.
///
/// Отображает логотип приложения по центру на синем фоне
/// с эффектом медленной пульсации.
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Duration? minimumDuration;
  late bool _minDurationPassed;

  @override
  void initState() {
    super.initState();

    _initBlocs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDuration();
    });
  }

  void _initBlocs() {
    context.read<SettingsCubit>().init();
    context.read<AuthCubit>().init();
    context.read<SummaryAuthCubit>().init();
  }

  void _checkDuration() {
    minimumDuration = AppConfigProvider.of(context).splashMinDuration;

    switch (minimumDuration == null) {
      case true:
        _minDurationPassed = true;
      case false:
        _minDurationPassed = false;
        _startMinimumDurationTimer();
    }
  }

  void _startMinimumDurationTimer() {
    Future.delayed(minimumDuration!, () {
      if (!mounted) {
        return;
      }
      setState(() => _minDurationPassed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsStatus = context.select(
      (SettingsCubit cubit) => cubit.state.status,
    );

    final authStatus = context.select(
      (AuthCubit cubit) => cubit.state.status,
    );

    /// Проверка на ошибки инициализации
    if (settingsStatus == .failure) {
      return _ErrorView(onRetry: () => _initBlocs());
    }

    /// Проверка на завершение загрузки всех критичных BLoCs
    final initComplete = settingsStatus == .success && authStatus != .loading;

    /// Инициализация завершена
    if (initComplete && _minDurationPassed) {
      AppConfigProvider.repo(context).setInitialized();
    }

    /// Виджет загрузки приложения
    return const _SplashView();
  }
}
