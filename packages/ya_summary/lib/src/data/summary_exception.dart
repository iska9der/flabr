class SummaryException implements Exception {
  SummaryException([this.message]);

  final String? message;

  @override
  String toString() {
    return message ?? 'Не удалось получить данные';
  }
}
