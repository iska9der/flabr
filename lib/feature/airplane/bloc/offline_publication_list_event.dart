part of 'offline_publication_list_bloc.dart';

@freezed
sealed class OfflinePublicationListEvent with _$OfflinePublicationListEvent {
  const factory OfflinePublicationListEvent.load() = _LoadEvent;
}
