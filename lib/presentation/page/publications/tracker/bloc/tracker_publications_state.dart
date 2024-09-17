part of 'tracker_publications_bloc.dart';

@freezed
class TrackerPublicationsState with _$TrackerPublicationsState {
  const TrackerPublicationsState._();

  const factory TrackerPublicationsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    @Default(TrackerPublicationsResponse())
    TrackerPublicationsResponse response,
    @Default(1) int page,
  }) = _TrackerPublicationsState;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.list.pagesCount;
}
