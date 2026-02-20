part of 'offline_publication_bloc.dart';

@freezed
abstract class OfflinePublicationState with _$OfflinePublicationState {
  const factory OfflinePublicationState.initial() = _InitialState;

  const factory OfflinePublicationState.loading() = _LoadingState;

  const factory OfflinePublicationState.success() = _SuccessState;

  const factory OfflinePublicationState.failure({
    required String error,
  }) = _FailureState;
}
