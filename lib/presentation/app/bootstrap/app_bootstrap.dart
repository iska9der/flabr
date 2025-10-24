import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/settings/settings_cubit.dart';

typedef ErrorBuilder =
    Widget Function(BuildContext context, VoidCallback retry);

/// Статус загрузки приложения
class _BootstrapStatus {
  const _BootstrapStatus({
    required this.settingsReady,
    required this.settingsError,
  });

  final bool settingsReady;
  final bool settingsError;
}

/// Управляет процессом инициализации приложения и отображением splash screen.
///
/// Отслеживает статусы критичных BLoCs ([SettingsCubit], [AuthCubit])
/// и показывает splash screen пока они не завершат инициализацию.
///
/// Если [minimumDuration] задан, splash screen будет отображаться минимум
/// указанное время, чтобы избежать мелькания при быстрой инициализации.
///
/// Если инициализация завершается с ошибкой, показывается error screen
/// с возможностью повторной попытки.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({
    required this.child,
    this.splash,
    this.errorBuilder,
    this.minimumDuration,
    super.key,
  });

  final Widget child;
  final Widget? splash;
  final ErrorBuilder? errorBuilder;

  /// Минимальная длительность отображения splash screen.
  /// Если null, splash скрывается сразу после завершения инициализации.
  final Duration? minimumDuration;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late bool _minimumDurationPassed;

  @override
  void initState() {
    super.initState();

    _initBlocs();

    if (widget.minimumDuration == null) {
      _minimumDurationPassed = true;
    } else {
      _minimumDurationPassed = false;
      _startMinimumDurationTimer();
    }

    /// Убираем нативный экран загрузки
    FlutterNativeSplash.remove();
  }

  void _startMinimumDurationTimer() {
    Future.delayed(widget.minimumDuration!, () {
      if (!mounted) {
        return;
      }
      setState(() => _minimumDurationPassed = true);
    });
  }

  void _initBlocs() {
    context.read<SettingsCubit>().init();
    context.read<AuthCubit>().init();
    context.read<SummaryAuthCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.splash == null) {
      return widget.child;
    }

    return BlocSelector<SettingsCubit, SettingsState, _BootstrapStatus>(
      selector: (state) => _BootstrapStatus(
        settingsReady: state.status == SettingsStatus.success,
        settingsError: state.status == SettingsStatus.failure,
      ),
      builder: (context, status) {
        final authStatus = context.select(
          (AuthCubit cubit) => cubit.state.status,
        );

        /// Проверка на ошибки инициализации
        if (status.settingsError) {
          return switch (widget.errorBuilder) {
            ErrorBuilder builder => builder(context, () => _initBlocs()),
            null => _DefaultErrorWidget(
              onRetry: () => _initBlocs(),
            ),
          };
        }

        /// Проверка на завершение загрузки всех критичных BLoCs
        final initializationComplete =
            status.settingsReady && authStatus != AuthStatus.loading;

        /// Инициализация завершена
        if (initializationComplete && _minimumDurationPassed) {
          return widget.child;
        }

        /// Виджет загрузки приложения
        return widget.splash!;
      },
    );
  }
}

/// Виджет по умолчанию для отображения ошибок инициализации
class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Ошибка инициализации приложения',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Не удалось загрузить необходимые данные',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
