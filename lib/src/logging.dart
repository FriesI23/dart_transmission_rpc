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

  void debug(String message);
  void info(String message);
  void warn(String message);
  void error(String message, {Object? error});
  void trace(String message, {Object? error, StackTrace? stackTrace});

  factory Logger(String name) =>
      _loggers.putIfAbsent(name, () => Logger._named(name));

  factory Logger._named(String name) => _Logger(name);
}

class _Logger implements Logger {
  int seq = 0;

  @override
  Zone? zone;
  @override
  final String name;

  _Logger(this.name);

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

  @override
  void debug(String message) => _log(message, LogLevel.debug);

  @override
  void info(String message) => _log(message, LogLevel.info);

  @override
  void warn(String message) => _log(message, LogLevel.warn);

  @override
  void error(String message, {Object? error}) =>
      _log(message, LogLevel.error, error: error);

  @override
  void trace(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, LogLevel.error, error: error, stackTrace: stackTrace);
}
