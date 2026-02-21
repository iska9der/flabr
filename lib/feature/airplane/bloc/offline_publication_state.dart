part of 'offline_publication_bloc.dart';

@freezed
abstract class OfflinePublicationState with _$OfflinePublicationState {
  const factory OfflinePublicationState({
    @Default({}) Set<String> idsInDb,
    @Default({}) Set<String> loadingIds,
    Object? error,
  }) = _OfflinePublicationState;
}
