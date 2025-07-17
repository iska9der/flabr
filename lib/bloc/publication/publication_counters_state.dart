part of 'publication_counters_bloc.dart';

@freezed
abstract class PublicationCountersState with _$PublicationCountersState {
  const factory PublicationCountersState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(PublicationCounters()) PublicationCounters counters,
    @Default('') String error,
  }) = _PublicationCountersState;
}
