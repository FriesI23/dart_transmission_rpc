// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'exception.dart';
import 'request.dart';
import 'response.dart';
import 'typedef.dart';
import 'version.dart';

const kMaxRpcTag = (1 << 63) - 1;

enum HttpProtocol { http, https }

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
