part of 'tracker_publications_marker_bloc.dart';

@freezed
class TrackerPublicationsMarkerEvent with _$TrackerPublicationsMarkerEvent {
  const factory TrackerPublicationsMarkerEvent.mark({
    required String id,
    required bool isMarked,
    @Default(false) bool isUnreaded,
  }) = MarkEvent;

  const factory TrackerPublicationsMarkerEvent.remove() = RemoveEvent;

  const factory TrackerPublicationsMarkerEvent.read() = ReadEvent;
}
