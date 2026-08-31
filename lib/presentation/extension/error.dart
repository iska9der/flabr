import '../../bloc/error/app_failure.dart';
import '../../data/exception/exception.dart';
import '../../i18n/i18n.dart';

extension ErrorTranslations on Translations {
  String errorMessage(Object? error) {
    final cause = error is AppFailure ? error.cause : error;

    final specificMessage = switch (cause) {
      CommentsListException(errorCode: final errorCode) => switch (errorCode) {
        'NOT_FOUND' => this.error.notFound,
        'POST_IN_DRAFTS' => comment.publication.inDrafts,
        'POST_COMMENTS_DISABLED' => comment.disabled,
        _ => comment.fetchFailed,
      },
      FetchException(type: final type) => switch (type) {
        FetchExceptionType.requestFailed => this.error.requestFailed,
        FetchExceptionType.bookmarkCommentsLoadFailed =>
          bookmark.comments.loadFailed,
        FetchExceptionType.userCommentsLoadFailed => user.comments.loadFailed,
      },
      MissingMimeTypeException() => image.missingMimeType,
      NotFoundException() => this.error.notFound,
      ValueException(type: final type) => switch (type) {
        ValueExceptionType.invalidValue => this.error.valueError,
        ValueExceptionType.unknownHub => hub.type.unknown,
        ValueExceptionType.unknownFeedPublication =>
          feed.publication.unknownType,
        ValueExceptionType.unknownPublicationFlow => publication.flow.unknown,
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
        AppFailureType.companyProfileFetchFailed => company.profile.fetchFailed,
        AppFailureType.companyListFetchFailed => company.list.fetchFailed,
        AppFailureType.hubProfileFetchFailed => hub.profile.fetchFailed,
        AppFailureType.hubListFetchFailed => hub.list.fetchFailed,
        AppFailureType.hubArticlesFetchFailed => hub.articles.fetchFailed,
        AppFailureType.publicationCommentsFetchFailed =>
          publication.comments.fetchFailed,
        AppFailureType.feedPublicationsFetchFailed =>
          feed.publications.fetchFailed,
        AppFailureType.publicationCountersFetchFailed =>
          publication.counters.fetchFailed,
        AppFailureType.publicationVotingEnded => publication.voting.ended,
        AppFailureType.publicationDailyVoteLimitReached =>
          publication.voting.dailyLimitReached,
        AppFailureType.publicationInsufficientRatingToVote =>
          publication.voting.insufficientRating,
        AppFailureType.publicationVotingNoLongerAllowed =>
          publication.voting.noLongerAllowed,
        AppFailureType.publicationUpvoteFailed =>
          publication.voting.upvoteFailed,
        AppFailureType.publicationDownvoteUnavailable =>
          publication.voting.downvoteUnavailable,
        AppFailureType.trackerNotificationsFetchFailed =>
          tracker.notifications.fetchFailed,
        AppFailureType.trackerPublicationsMarkReadFailed =>
          tracker.publications.markReadFailed,
        AppFailureType.trackerNotificationsMarkReadFailed =>
          tracker.notifications.markReadFailed,
        AppFailureType.trackerPublicationsRemoveFailed =>
          tracker.publications.removeFailed,
        AppFailureType.trackerPublicationReadFailed =>
          tracker.publications.readFailed,
        AppFailureType.userBookmarksFetchFailed => user.bookmarks.fetchFailed,
        AppFailureType.userProfileCardFetchFailed =>
          user.profile.cardFetchFailed,
        AppFailureType.userListFetchFailed => user.list.fetchFailed,
        AppFailureType.summaryAuthorizationRequired =>
          summary.authorizationRequired,
        AppFailureType.summarySharingUrlFetchFailed => summary.link.fetchError,
        AppFailureType.summaryFetchFailed => summary.fetchError,
        AppFailureType.summaryOperationFailed => summary.brief.fetchError,
      };
    }

    return this.error.somethingWentWrong;
  }
}
