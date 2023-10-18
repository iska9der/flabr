import 'displayable_exception.dart';

class ExceptionHelper {
  static String parseMessage(
    Object exception, [
    String fallback = 'Не удалось выполнить',
    StackTrace? trace,
  ]) {
    if (exception is DisplayableException) {
      return exception.toString();
    }

    return fallback;
  }
}
