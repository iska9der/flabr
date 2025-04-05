part of 'publication_counters_bloc.dart';

@freezed
class PublicationCountersEvent with _$PublicationCountersEvent {
  const factory PublicationCountersEvent.load() = LoadEvent;
}
