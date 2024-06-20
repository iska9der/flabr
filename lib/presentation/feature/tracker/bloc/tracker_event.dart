part of 'tracker_bloc.dart';

@freezed
class TrackerEvent with _$TrackerEvent {
  const factory TrackerEvent.load() = TrackerLoad;
}
