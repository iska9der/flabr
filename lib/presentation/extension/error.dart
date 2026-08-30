import '../../bloc/error/app_failure.dart';
import '../../data/exception/exception.dart';
import '../../i18n/i18n.dart';

extension ErrorTranslations on Translations {
  String errorMessage(Object? error) {
    final cause = error is AppFailure ? error.cause : error;

    final specificMessage = switch (cause) {
      CommentsListException(errorCode: final errorCode) => switch (errorCode) {
        'NOT_FOUND' => this.error.notFound,
        'POST_IN_DRAFTS' => comment.publicationInDrafts,
        'POST_COMMENTS_DISABLED' => comment.disabled,
        _ => comment.fetchFailed,
      },
      FetchException(type: final type) => switch (type) {
        FetchExceptionType.requestFailed => this.error.requestFailed,
        FetchExceptionType.bookmarkCommentsLoadFailed =>
          bookmark.commentsLoadFailed,
        FetchExceptionType.userCommentsLoadFailed => user.commentsLoadFailed,
      },
      MissingMimeTypeException() => image.missingMimeType,
      NotFoundException() => this.error.notFound,
      ValueException(type: final type) => switch (type) {
        ValueExceptionType.invalidValue => this.error.valueError,
        ValueExceptionType.unknownHub => hub.unknownType,
        ValueExceptionType.unknownFeedPublication =>
          feed.publicationUnknownType,
        ValueExceptionType.unknownPublicationFlow => publication.unknownFlow,
        ValueExceptionType.unknownSort => sort.unknownValue,
        ValueExceptionType.unknownLanguage => language.unknown,
        ValueExceptionType.searchNotImplemented => search.notImplemented,
        ValueExceptionType.wrongPublicationDestination =>
          publication.wrongDestination,
        ValueExceptionType.publicationOperationFailed => publication.failed,
      },
      String message when message.isNotEmpty => message,
      _ => null,
    };

    if (specificMessage != null) {
      return specificMessage;
    }

    if (error is AppFailure) {
      return switch (error.type) {
        AppFailureType.operationFailed => this.error.operationFailed,
        AppFailureType.companyProfileFetchFailed => company.profileFetchFailed,
        AppFailureType.companyListFetchFailed => company.listFetchFailed,
        AppFailureType.hubProfileFetchFailed => hub.profileFetchFailed,
        AppFailureType.hubListFetchFailed => hub.listFetchFailed,
        AppFailureType.hubArticlesFetchFailed => hub.articlesFetchFailed,
        AppFailureType.publicationCommentsFetchFailed =>
          publication.commentsFetchFailed,
        AppFailureType.feedPublicationsFetchFailed =>
          feed.publicationsFetchFailed,
        AppFailureType.publicationCountersFetchFailed =>
          publication.countersFetchFailed,
        AppFailureType.publicationVotingEnded => publication.votingEnded,
        AppFailureType.publicationDailyVoteLimitReached =>
          publication.dailyVoteLimitReached,
        AppFailureType.publicationInsufficientRatingToVote =>
          publication.insufficientRatingToVote,
        AppFailureType.publicationVotingNoLongerAllowed =>
          publication.votingNoLongerAllowed,
        AppFailureType.publicationUpvoteFailed => publication.upvoteFailed,
        AppFailureType.publicationDownvoteUnavailable =>
          publication.downvoteUnavailable,
        AppFailureType.trackerNotificationsFetchFailed =>
          tracker.notificationsFetchFailed,
        AppFailureType.trackerPublicationsMarkReadFailed =>
          tracker.publicationsMarkReadFailed,
        AppFailureType.trackerNotificationsMarkReadFailed =>
          tracker.notificationsMarkReadFailed,
        AppFailureType.trackerPublicationsRemoveFailed =>
          tracker.publicationsRemoveFailed,
        AppFailureType.trackerPublicationReadFailed =>
          tracker.publicationReadFailed,
        AppFailureType.userBookmarksFetchFailed => user.bookmarksFetchFailed,
        AppFailureType.userProfileCardFetchFailed =>
          user.profileCardFetchFailed,
        AppFailureType.userListFetchFailed => user.listFetchFailed,
        AppFailureType.summaryAuthorizationRequired =>
          summary.authorizationRequired,
        AppFailureType.summarySharingUrlFetchFailed => summary.linkFetchError,
        AppFailureType.summaryFetchFailed => summary.fetchError,
        AppFailureType.summaryOperationFailed => summary.briefFetchError,
      };
    }

    return this.error.somethingWentWrong;
  }
}
