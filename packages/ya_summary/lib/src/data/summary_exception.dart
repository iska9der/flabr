import '../../i18n/i18n.dart';

class SummaryException implements Exception {
  SummaryException([this.message]);

  final String? message;

  @override
  String toString() {
    return message ?? yaSummaryT.summary.dataFetchError;
  }
}
