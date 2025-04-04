abstract class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() {
    var message = this.message;

    if (message == null) {
      return 'Что-то пошло не так';
    }

    return message;
  }
}
