part of 'logger.dart';

class ConsoleLogger implements Logger {
  @override
  void info(Object message, {String? title}) {
    if (title != null) {
      dev.log('$title >', name: 'INFO');
      message = '$message';
    }

    if (message is! String) {
      message = message.toString();
    }

    dev.log(message, name: 'INFO');
  }

  @override
  void warning(Object message, {String? title, StackTrace? stackTrace}) {
    if (title != null) {
      dev.log('$title >', name: 'WARNING');
      message = '$message';
    }

    dev.log('$message', name: 'WARNING', stackTrace: stackTrace);
  }

  @override
  void error(Object message, Object exception, StackTrace? trace) {
    dev.log(
      '${exception.toString()} >',
      name: 'ERROR',
      error: exception,
      stackTrace: trace,
    );
  }
}
