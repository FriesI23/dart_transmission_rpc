// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:developer';

enum LogLevel {
  debug(1200),
  info(800),
  warn(900),
  error(500);

  final int number;

  const LogLevel(this.number);
}

abstract class Logger {
  static final Map<String, Logger> _loggers = {};

  String get name;
  Zone? get zone;
  set zone(Zone? newZone);

  void debug(String message, {List<dynamic>? args});
  void info(String message, {List<dynamic>? args});
  void warn(String message, {List<dynamic>? args});
  void error(String message, {List<dynamic>? args, Object? error});
  void trace(String message,
      {List<dynamic>? args, Object? error, StackTrace? stackTrace});

  factory Logger(String name, {LogLevel showLevel = LogLevel.info}) => _loggers
      .putIfAbsent(name, () => Logger._named(name, showLevel: showLevel));

  factory Logger._named(String name, {required LogLevel showLevel}) =>
      _Logger(name, showLevel: showLevel);
}

class _Logger implements Logger {
  int seq = 0;

  final LogLevel showLevel;

  @override
  Zone? zone;
  @override
  final String name;

  _Logger(
    this.name, {
    required this.showLevel,
  });

  void _log(String message, LogLevel level,
      {Object? error, StackTrace? stackTrace}) {
    log(message,
        name: name,
        level: level.number,
        error: error,
        stackTrace: stackTrace,
        sequenceNumber: seq,
        zone: zone);
    seq += 1;
  }

  bool shouldShowLog(LogLevel logLevel) {
    return logLevel.number <= showLevel.number;
  }

  String join(message, List<dynamic>? args) =>
      message + (args != null ? "|" : " + ") + (args?.join("|") ?? "");

  @override
  void debug(String message, {List<dynamic>? args}) =>
      shouldShowLog(LogLevel.debug)
          ? _log(join(message, args), LogLevel.debug)
          : null;

  @override
  void info(String message, {List<dynamic>? args}) =>
      shouldShowLog(LogLevel.info)
          ? _log(join(message, args), LogLevel.info)
          : null;

  @override
  void warn(String message, {List<dynamic>? args}) =>
      shouldShowLog(LogLevel.warn)
          ? _log(join(message, args), LogLevel.warn)
          : null;

  @override
  void error(String message, {List<dynamic>? args, Object? error}) =>
      trace(message, args: args, error: error);

  @override
  void trace(String message,
          {List<dynamic>? args, Object? error, StackTrace? stackTrace}) =>
      shouldShowLog(LogLevel.error)
          ? _log(join(message, args), LogLevel.error,
              error: error, stackTrace: stackTrace)
          : null;
}
