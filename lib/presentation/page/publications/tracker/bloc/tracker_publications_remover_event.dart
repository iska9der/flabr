part of 'tracker_publications_remover_bloc.dart';

@freezed
class TrackerPublicationsRemoverEvent with _$TrackerPublicationsRemoverEvent {
  const factory TrackerPublicationsRemoverEvent.mark({
    required String id,
    required bool isMarked,
  }) = MarkEvent;

  const factory TrackerPublicationsRemoverEvent.remove() = RemoveEvent;
}
