part of 'offline_publication_bloc.dart';

@freezed
sealed class OfflinePublicationEvent with _$OfflinePublicationEvent {
  const factory OfflinePublicationEvent.load() = _LoadEvent;

  const factory OfflinePublicationEvent.setSaved({
    required Publication publication,
    required bool saved,
  }) = _SetSavedEvent;

  const factory OfflinePublicationEvent.changed(
    List<PublicationOffline> publications,
  ) = _ChangedEvent;

  const factory OfflinePublicationEvent.failed(
    Object error,
    StackTrace stackTrace,
  ) = _FailedEvent;
}
