part of 'offline_publication_bloc.dart';

@freezed
sealed class OfflinePublicationEvent with _$OfflinePublicationEvent {
  const factory OfflinePublicationEvent.load() = _LoadEvent;

  const factory OfflinePublicationEvent.toggle(Publication publication) =
      _ToggleEvent;
}
