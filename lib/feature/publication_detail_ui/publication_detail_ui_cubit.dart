import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_detail_ui_cubit.freezed.dart';
part 'publication_detail_ui_state.dart';

/// Управление UI состоянием детальной страницы публикации
/// Отслеживает видимость элементов управления (AppBar/BottomBar) и прогресс скролла
class PublicationDetailUICubit extends Cubit<PublicationDetailUIState> {
  PublicationDetailUICubit() : super(const PublicationDetailUIState());

  /// Обновить прогресс скролла (0.0 - 1.0)
  /// Использует debouncing для избежания множественных emit'ов
  void updateScrollProgress(double normalized) {
    // Игнорируем изменения менее 0.1% для уменьшения количества перестроек
    if ((state.scrollProgress - normalized).abs() < 0.001) return;
    emit(state.copyWith(scrollProgress: normalized.clamp(0.0, 1.0)));
  }

  /// Показать AppBar и BottomBar
  void showBars() {
    if (state.barsVisible) return;
    emit(state.copyWith(barsVisible: true));
  }

  /// Скрыть AppBar и BottomBar
  void hideBars() {
    if (!state.barsVisible) return;
    emit(state.copyWith(barsVisible: false));
  }

  /// Сбросить состояние в исходное
  void reset() {
    emit(const PublicationDetailUIState());
  }
}
