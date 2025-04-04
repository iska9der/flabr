part of 'tracker_publications_bloc.dart';

@freezed
class TrackerPublicationsEvent with _$TrackerPublicationsEvent {
  const factory TrackerPublicationsEvent.load() = LoadEvent;
  const factory TrackerPublicationsEvent.subscribe() = SubscribeEvent;
}
