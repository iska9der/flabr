enum AppFailureType {
  operationFailed,
  companyProfileFetchFailed,
  companyListFetchFailed,
  hubProfileFetchFailed,
  hubListFetchFailed,
  hubArticlesFetchFailed,
  publicationCommentsFetchFailed,
  feedPublicationsFetchFailed,
  publicationCountersFetchFailed,
  publicationVotingEnded,
  publicationDailyVoteLimitReached,
  publicationInsufficientRatingToVote,
  publicationVotingNoLongerAllowed,
  publicationUpvoteFailed,
  publicationDownvoteUnavailable,
  trackerNotificationsFetchFailed,
  trackerPublicationsMarkReadFailed,
  trackerNotificationsMarkReadFailed,
  trackerPublicationsRemoveFailed,
  trackerPublicationReadFailed,
  userBookmarksFetchFailed,
  userProfileCardFetchFailed,
  userListFetchFailed,
  summaryAuthorizationRequired,
  summarySharingUrlFetchFailed,
  summaryFetchFailed,
  summaryOperationFailed,
}

final class AppFailure {
  const AppFailure(this.type, [this.cause]);

  final AppFailureType type;
  final Object? cause;
}
