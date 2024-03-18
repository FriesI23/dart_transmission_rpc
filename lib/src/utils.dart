// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'exception.dart';
import 'model/torrent.dart';
import 'request.dart';
import 'response.dart';
import 'typedef.dart';
import 'version.dart';

const kMaxRpcTag = (1 << 63) - 1;

enum HttpProtocol { http, https }

/// see libtransmission/transmission.h::tr_priority_t
/// since Normal is 0, memset initializes nicely
enum BandwidthPriority {
  low(-1),
  normal(0),
  high(1);

  final num nice;

  const BandwidthPriority(this.nice);

  factory BandwidthPriority.nice(num nice) {
    switch (nice) {
      case 1:
        return BandwidthPriority.high;
      case -1:
        return BandwidthPriority.low;
      default:
        return BandwidthPriority.normal;
    }
  }
}

enum IdleLimitMode {
  /// follow the global settings
  global(0),

  /// verride the global settings, seeding until a certain idle time
  single(1),

  /// override the global settings, seeding regardless of activity
  unlimited(2);

  final int code;

  const IdleLimitMode(this.code);

  factory IdleLimitMode.code(int code) {
    switch (code) {
      case 1:
        return IdleLimitMode.single;
      case 2:
        return IdleLimitMode.unlimited;
      default:
        return IdleLimitMode.global;
    }
  }
}

enum RatioLimitMode {
  /// follow the global settings
  global(0),

  /// verride the global settings, seeding until a certain idle time
  single(1),

  /// override the global settings, seeding regardless of activity
  unlimited(2);

  final int code;

  const RatioLimitMode(this.code);

  factory RatioLimitMode.code(int code) {
    switch (code) {
      case 1:
        return RatioLimitMode.single;
      case 2:
        return RatioLimitMode.unlimited;
      default:
        return RatioLimitMode.global;
    }
  }
}

enum ServerErrorCode {
  /// everything's fine
  ok(0),

  /// when server announced to the tracker, it got a warning in the response
  tackerWarning(1),

  /// when server announced to the tracker, it got an error in the response
  trackerError(2),

  /// server local trouble, such as disk full or permissions error
  localError(3);

  final int code;

  const ServerErrorCode(this.code);

  factory ServerErrorCode.code(int code) {
    switch (code) {
      case 1:
        return ServerErrorCode.tackerWarning;
      case 2:
        return ServerErrorCode.trackerError;
      case 3:
        return ServerErrorCode.localError;
      default:
        return ServerErrorCode.ok;
    }
  }
}

dynamic toRpcJsonByType<T>(dynamic val) {
  switch (val.runtimeType) {
    case TorrentIds _:
      val as TorrentIds;
      return val.toRpcJson();
    case FileIndices _:
      val as FileIndices;
      return val.toRpcJson();
    default:
      return val;
  }
}

T _buildParam<T>({
  String? label,
  ServerRpcVersion? version,
  required List args,
  required Iterable<MapEntry<int, T Function(List)>> versionBuilers,
  required T Function(List) nullVersionBuilder,
  T Function(List)? defaultVersionBuilder,
}) {
  if (version == null) return nullVersionBuilder(args);
  for (var kv in versionBuilers) {
    if (version.checkApiVersionValidate(v: kv.key)) return kv.value(args);
  }
  if (defaultVersionBuilder == null) return nullVersionBuilder(args);
  if (version.checkApiVersionValidate()) return defaultVersionBuilder(args);
  throw TransmissionVersionError("Incompatible API version on ${label ?? T}",
      version.rpcVersion, version.minRpcVersion);
}

S buildRequestParam1<S extends RequestParam, V>(
  ServerRpcVersion? version,
  V arg, {
  String? label,
  Iterable<ParamBuilderEntry1<S, V>> versionBuilers = const [],
  required S Function(V arg) nullVersionBuilder,
  S Function(V arg)? defaultVersionBuilder,
}) =>
    _buildParam(
      label: label,
      version: version,
      args: [arg],
      versionBuilers: versionBuilers
          .map((e) => MapEntry(e.key, (args) => e.value(args[0]))),
      nullVersionBuilder: (args) => nullVersionBuilder(args.first),
      defaultVersionBuilder: defaultVersionBuilder != null
          ? (args) => defaultVersionBuilder(args.first)
          : null,
    );

S buildRequestParam2<S extends RequestParam, V1, V2>(
  ServerRpcVersion? version,
  V1 arg1,
  V2 arg2, {
  String? label,
  Iterable<ParamBuilderEntry2<S, V1, V2>> versionBuilers = const [],
  required S Function(V1 arg1, V2 arg2) nullVersionBuilder,
  S Function(V1 arg1, V2 arg2)? defaultVersionBuilder,
}) =>
    _buildParam(
      label: label,
      version: version,
      args: [arg1, arg2],
      versionBuilers: versionBuilers
          .map((e) => MapEntry(e.key, (args) => e.value(args[0], args[1]))),
      nullVersionBuilder: (args) => nullVersionBuilder(args[0], args[1]),
      defaultVersionBuilder: defaultVersionBuilder != null
          ? (args) => defaultVersionBuilder(args[0], args[1])
          : null,
    );

S buildResponseParam1<S extends ResponseParam, V>(
  ServerRpcVersion? version,
  V arg, {
  String? label,
  Iterable<ParamBuilderEntry1<S, V>> versionBuilers = const [],
  required S Function(V arg) nullVersionBuilder,
  S Function(V arg)? defaultVersionBuilder,
}) =>
    _buildParam(
      label: label,
      version: version,
      args: [arg],
      versionBuilers: versionBuilers
          .map((e) => MapEntry(e.key, (args) => e.value(args[0]))),
      nullVersionBuilder: (args) => nullVersionBuilder(args.first),
      defaultVersionBuilder: defaultVersionBuilder != null
          ? (args) => defaultVersionBuilder(args.first)
          : null,
    );

S buildResponseParam2<S extends ResponseParam, V1, V2>(
  ServerRpcVersion? version,
  V1 arg1,
  V2 arg2, {
  String? label,
  Iterable<ParamBuilderEntry2<S, V1, V2>> versionBuilers = const [],
  required S Function(V1 arg1, V2 arg2) nullVersionBuilder,
  S Function(V1 arg1, V2 arg2)? defaultVersionBuilder,
}) =>
    _buildParam(
      label: label,
      version: version,
      args: [arg1, arg2],
      versionBuilers: versionBuilers
          .map((e) => MapEntry(e.key, (args) => e.value(args[0], args[1]))),
      nullVersionBuilder: (args) => nullVersionBuilder(args[0], args[1]),
      defaultVersionBuilder: defaultVersionBuilder != null
          ? (args) => defaultVersionBuilder(args[0], args[1])
          : null,
    );
