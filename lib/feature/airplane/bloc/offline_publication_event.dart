part of 'offline_publication_bloc.dart';

@freezed
sealed class OfflinePublicationEvent with _$OfflinePublicationEvent {
  const factory OfflinePublicationEvent.create({
    required Publication publication,
  }) = _CreateEvent;

  const factory OfflinePublicationEvent.delete({
    required String id,
  }) = _DeleteEvent;
}
