part of 'part.dart';

@freezed
class TrackerPublicationsResponse with _$TrackerPublicationsResponse {
  const factory TrackerPublicationsResponse({
    @Default(PublicationListResponse.empty)
    PublicationListResponse listResponse,
    @Default(TrackerUnreadCounters()) TrackerUnreadCounters unreadCounters,
  }) = _TrackerPublicationsResponse;
}
