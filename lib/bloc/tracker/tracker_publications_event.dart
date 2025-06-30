part of 'tracker_publications_bloc.dart';

@freezed
sealed class TrackerPublicationsEvent with _$TrackerPublicationsEvent {
  const factory TrackerPublicationsEvent.subscribe() = SubscribeEvent;

  const factory TrackerPublicationsEvent.load() = LoadEvent;
}
