part of 'tracker_publications_bloc.dart';

@freezed
sealed class TrackerPublicationsEvent with _$TrackerPublicationsEvent {
  const factory TrackerPublicationsEvent.subscribe() = _SubscribeEvent;

  const factory TrackerPublicationsEvent.load() = _LoadEvent;

  const factory TrackerPublicationsEvent.loaded(
    ListResponse<TrackerPublication> response,
  ) = _LoadedEvent;
}
