import 'dart:developer' as dev;

class ConsoleLogger {
  static void info(String message, {String? title}) {
    if (title != null) {
      dev.log(
        '$title >',
        name: 'INFO',
      );

      message = '\t $message';
    }

    dev.log(
      message,
      name: 'INFO',
    );
  }
}
