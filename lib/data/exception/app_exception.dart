abstract class AppException implements Exception {
  const AppException();

  @override
  String toString() => runtimeType.toString();
}
