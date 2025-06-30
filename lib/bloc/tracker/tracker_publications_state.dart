part of 'tracker_publications_bloc.dart';

@freezed
abstract class TrackerPublicationsState with _$TrackerPublicationsState {
  const TrackerPublicationsState._();

  const factory TrackerPublicationsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String error,
    @Default(TrackerPublicationListResponse.empty)
    ListResponse<TrackerPublication> response,
    @Default(1) int page,
  }) = _TrackerPublicationsState;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.pagesCount;
}
