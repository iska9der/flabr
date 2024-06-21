part of 'part.dart';

@freezed
class TrackerPublicationsResponse with _$TrackerPublicationsResponse {
  const factory TrackerPublicationsResponse({
    @Default(TrackerPublicationListResponse.empty)
    TrackerPublicationListResponse listResponse,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerPublicationsResponse;
}
