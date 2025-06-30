part of 'tracker_publications_marker_bloc.dart';

@freezed
sealed class TrackerPublicationsMarkerEvent
    with _$TrackerPublicationsMarkerEvent {
  const factory TrackerPublicationsMarkerEvent.mark({
    required String id,
    required bool isMarked,
    @Default(false) bool isUnreaded,
  }) = MarkEvent;

  const factory TrackerPublicationsMarkerEvent.read({required String id}) =
      ReadEvent;

  const factory TrackerPublicationsMarkerEvent.readMarked() = ReadMarkedEvent;

  const factory TrackerPublicationsMarkerEvent.removeMarked() =
      RemoveMarkedEvent;
}
