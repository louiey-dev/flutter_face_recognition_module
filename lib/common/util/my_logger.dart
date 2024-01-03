import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/*
  Logger  : https://pub.dev/packages/logger

  You can log with different levels:
    logger.v("Verbose log");
    logger.d("Debug log");
    logger.i("Info log");
    logger.w("Warning log");
    logger.e("Error log");
    logger.wtf("What a terrible failure log");

  To show only specific log levels, you can set:
    Logger.level = Level.warning;
*/
var logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      // lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);

void userLog(String log) {
  if (kDebugMode) {
    logger.d(log);
  }
}

void userLogD(String log) {
  if (kDebugMode) {
    logger.d(log);
  }
}

void userLogV(String log) {
  if (kDebugMode) {
    logger.v(log);
  }
}

void userLogI(String log) {
  if (kDebugMode) {
    logger.i(log);
  }
}

void userLogW(String log) {
  if (kDebugMode) {
    logger.w(log);
  }
}

void userLogE(String log) {
  if (kDebugMode) {
    logger.e(log);
  }
}

void userErr(String log) {
  if (kDebugMode) {
    logger.wtf(log);
  }
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////