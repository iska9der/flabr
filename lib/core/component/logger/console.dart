import 'dart:developer' as dev;

final Logger logger = ConsoleLogger();

abstract interface class Logger {
  void info(dynamic message, {String? title});

  void error(Object exception, StackTrace trace);
}

class ConsoleLogger implements Logger {
  @override
  void info(dynamic message, {String? title}) {
    if (title != null) {
      dev.log('$title >', name: 'INFO');

      message = '\t $message';
    }

    dev.log('$message', name: 'INFO');
  }

  @override
  void error(Object exception, StackTrace trace) {
    dev.log(
      '${exception.toString()} >',
      name: 'ERROR',
      error: exception,
      stackTrace: trace,
    );
  }
}
