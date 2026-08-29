import '../../i18n/i18n.dart';

abstract class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  String get defaultMessage => t.error.somethingWentWrong;

  @override
  String toString() => message ?? defaultMessage;
}
