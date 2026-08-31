enum SummaryExceptionType {
  tokenMissing,
  unauthorized,
  sharingUrlFetchFailed,
  summaryFetchFailed,
}

class SummaryException implements Exception {
  const SummaryException(this.type);

  final SummaryExceptionType type;

  @override
  String toString() => 'SummaryException(type: $type)';
}
