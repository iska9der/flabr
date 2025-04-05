part of 'tracker_publications_marker_bloc.dart';

@freezed
class TrackerPublicationsMarkerState with _$TrackerPublicationsMarkerState {
  const TrackerPublicationsMarkerState._();

  const factory TrackerPublicationsMarkerState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,

    /// Список отмеченных публикаций
    /// {идентификатор публикации: является ли публикация непрочитанной}
    /// Если в списке нет непрочитанных публикаций -
    /// не показываем кнопку "Пометить как прочитанное"
    @Default({}) Map<String, bool> markedIds,
  }) = _TrackerPublicationsRemoverState;

  bool get isAnyUnreaded => markedIds.values.any((isUnreaded) => isUnreaded);
}
