import 'dart:developer' as dev;

part 'console.dart';

abstract interface class Logger {
  void info(Object message, {String? title});

  void warning(Object message, {String? title, StackTrace? stackTrace});

  void error(
    Object message,
    Object exception,
    StackTrace? trace,
  );
}
