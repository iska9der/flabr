part of 'offline_publication_bloc.dart';

@freezed
abstract class OfflinePublicationState with _$OfflinePublicationState {
  const OfflinePublicationState._();

  const factory OfflinePublicationState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<PublicationOffline> publications,
    @Default({}) Set<String> loadingIds,
    String? error,
    String? operationError,
    String? operationErrorId,
  }) = _OfflinePublicationState;

  Set<String> get savedIds =>
      publications.map((item) => item.publication.id).toSet();
}
