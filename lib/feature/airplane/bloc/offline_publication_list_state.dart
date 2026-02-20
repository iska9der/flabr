part of 'offline_publication_list_bloc.dart';

@freezed
abstract class OfflinePublicationListState with _$OfflinePublicationListState {
  const factory OfflinePublicationListState.initial() = _InitialState;

  const factory OfflinePublicationListState.loading({
    @Default([]) List<Publication> models,
  }) = _LoadingState;

  const factory OfflinePublicationListState.success({
    required List<Publication> models,
  }) = _SuccessState;

  const factory OfflinePublicationListState.failure({
    @Default([]) List<Publication> models,
    required String error,
  }) = _FailureState;
}
