part of 'publication_detail_ui_cubit.dart';

@freezed
abstract class PublicationDetailUIState with _$PublicationDetailUIState {
  const factory PublicationDetailUIState({
    @Default(true) bool barsVisible,
    @Default(0.0) double scrollProgress,
  }) = _PublicationDetailUIState;
}
