// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:io';

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';
import 'torrent.dart';
import 'torrent_get.dart';

enum TorrentAddArgument {
  cookies(argName: "cookies"),
  downloadDir(argName: "download-dir"),
  filename(argName: "filename"),
  labels(argName: "labels"),
  metainfo(argName: "metainfo"),
  paused(argName: "paused"),
  peerLimit(argName: "peer-limit"),
  bandwidthPriority(argName: "bandwidthPriority"),
  filesWanted(argName: "files-wanted"),
  filesUnwanted(argName: "files-unwanted"),
  priorityHigh(argName: "priority-high"),
  priorityLow(argName: "priority-low"),
  priorityNormal(argName: "priority-normal");

  static final allFieldsSet = TorrentAddArgument.values.toSet();

  final String argName;

  const TorrentAddArgument({required this.argName});
}

class TorrentAddFileInfo {
  final String? filename;
  final List<int>? metainfo;

  const TorrentAddFileInfo({this.filename, this.metainfo})
      : assert(!(filename == null && metainfo == null));

  const TorrentAddFileInfo.byFilename(String this.filename) : metainfo = null;

  const TorrentAddFileInfo.byMetainfo(List<int> this.metainfo)
      : filename = null;

  JsonMap toRpcJson() => filename != null
      ? {TorrentAddArgument.filename.argName: filename}
      : {TorrentAddArgument.metainfo.argName: base64Encode(metainfo!)};
}

mixin TorrentAddRequestArgsDefine {
  /// Information about the torrent's files.
  TorrentAddFileInfo get fileInfo;

  /// One or more cookies.
  List<Cookie>? get cookies;

  /// Path to download the torrent to.
  String? get downloadDir;

  /// Indicates whether the torrent should be added in a paused state.
  bool? get paused;

  /// Maximum number of peers for the torrent.
  num? get peerLimit;

  /// Priority for the torrent's bandwidth.
  num? get bandwidthPriority;

  /// Indices of file(s) to be downloaded.
  FileIndices? get filesWanted;

  /// Indices of file(s) not to be downloaded.
  FileIndices? get filesUnwanted;

  /// Indices of high-priority file(s).
  FileIndices? get priorityHigh;

  /// Indices of low-priority file(s).
  FileIndices? get priorityLow;

  /// Indices of normal-priority file(s).
  FileIndices? get priorityNormal;

  /// Array of string labels.
  /// (new in rpc-version 17)
  List<String>? get labels;
}

class TorrentAddRequestArgs with TorrentAddRequestArgsDefine {
  static final _enumToPropertyMap = {
    TorrentAddArgument.filename: (TorrentAddRequestArgs args) =>
        args.fileInfo.filename,
    TorrentAddArgument.metainfo: (TorrentAddRequestArgs args) =>
        args.fileInfo.metainfo,
    TorrentAddArgument.cookies: (TorrentAddRequestArgs args) => args.cookies,
    TorrentAddArgument.downloadDir: (TorrentAddRequestArgs args) =>
        args.downloadDir,
    TorrentAddArgument.paused: (TorrentAddRequestArgs args) => args.paused,
    TorrentAddArgument.peerLimit: (TorrentAddRequestArgs args) =>
        args.peerLimit,
    TorrentAddArgument.bandwidthPriority: (TorrentAddRequestArgs args) =>
        args.bandwidthPriority,
    TorrentAddArgument.filesWanted: (TorrentAddRequestArgs args) =>
        args.filesWanted,
    TorrentAddArgument.filesUnwanted: (TorrentAddRequestArgs args) =>
        args.filesUnwanted,
    TorrentAddArgument.priorityHigh: (TorrentAddRequestArgs args) =>
        args.priorityHigh,
    TorrentAddArgument.priorityLow: (TorrentAddRequestArgs args) =>
        args.priorityLow,
    TorrentAddArgument.priorityNormal: (TorrentAddRequestArgs args) =>
        args.priorityNormal,
    TorrentAddArgument.labels: (TorrentAddRequestArgs args) => args.labels,
  };

  @override
  final TorrentAddFileInfo fileInfo;
  @override
  final List<Cookie>? cookies;
  @override
  final String? downloadDir;
  @override
  final bool? paused;
  @override
  final num? peerLimit;
  @override
  final num? bandwidthPriority;
  @override
  final FileIndices? filesWanted;
  @override
  final FileIndices? filesUnwanted;
  @override
  final FileIndices? priorityHigh;
  @override
  final FileIndices? priorityLow;
  @override
  final FileIndices? priorityNormal;
  // rpc17 new
  @override
  final List<String>? labels;

  TorrentAddRequestArgs({
    required this.fileInfo,
    this.cookies,
    this.downloadDir,
    this.paused,
    this.peerLimit,
    this.bandwidthPriority,
    this.filesWanted,
    this.filesUnwanted,
    this.priorityHigh,
    this.priorityLow,
    this.priorityNormal,
    this.labels,
  });

  Object? getValueByArgument(TorrentAddArgument arg) =>
      _enumToPropertyMap[arg]?.call(this);
}

abstract class TorrentAddRequestParam
    with TorrentAddRequestArgsDefine
    implements RequestParam {
  final TorrentAddRequestArgs _args;

  @override
  TorrentAddFileInfo get fileInfo => _args.fileInfo;

  @override
  List<Cookie>? get cookies => _args.cookies;

  @override
  String? get downloadDir => _args.downloadDir;

  @override
  bool? get paused => _args.paused;

  @override
  num? get peerLimit => _args.peerLimit;

  @override
  num? get bandwidthPriority => _args.bandwidthPriority;

  @override
  FileIndices? get filesWanted => _args.filesWanted;

  @override
  FileIndices? get filesUnwanted => _args.filesUnwanted;

  @override
  FileIndices? get priorityHigh => _args.priorityHigh;

  @override
  FileIndices? get priorityLow => _args.priorityLow;

  @override
  FileIndices? get priorityNormal => _args.priorityNormal;

  @override
  List<String>? get labels => _args.labels;

  const TorrentAddRequestParam({required TorrentAddRequestArgs args})
      : _args = args;

  static final _verionBuilderMap =
      <ParamBuilderEntry1<TorrentAddRequestParam, TorrentAddRequestArgs>>[
    MapEntry(17, (args) => _TorrentAddRequestParamRpc17(args: args)),
  ];

  factory TorrentAddRequestParam.build(
          {ServerRpcVersion? version, required TorrentAddRequestArgs args}) =>
      buildRequestParam1(version, args,
          nullVersionBuilder: (args) => _TorrentAddRequestParam(args: args),
          defaultVersionBuilder: (args) => _TorrentAddRequestParam(args: args),
          versionBuilers: _verionBuilderMap);

  Set<TorrentAddArgument> get allowedFields;
  Set<TorrentAddArgument> get deprecatedFields;
}

class _TorrentAddRequestParam extends TorrentAddRequestParam {
  static final _allowedFields = {
    TorrentAddArgument.cookies,
    TorrentAddArgument.downloadDir,
    TorrentAddArgument.filename,
    TorrentAddArgument.metainfo,
    TorrentAddArgument.paused,
    TorrentAddArgument.peerLimit,
    TorrentAddArgument.bandwidthPriority,
    TorrentAddArgument.filesWanted,
    TorrentAddArgument.filesUnwanted,
    TorrentAddArgument.priorityHigh,
    TorrentAddArgument.priorityLow,
    TorrentAddArgument.priorityNormal,
  };

  _TorrentAddRequestParam({required super.args});

  @override
  Set<TorrentAddArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentAddArgument> get deprecatedFields => {};

  @override
  String? check() {
    final notAllowedChecker = RequestParamArgsChecker<TorrentAddArgument>(
        label: "$runtimeType.prohibited",
        fields: TorrentAddArgument.allFieldsSet.difference(allowedFields),
        failedChecker: (f) => _args.getValueByArgument(f) != null);
    final deprecatedChecker = RequestParamArgsChecker<TorrentAddArgument>(
        label: "$runtimeType.deprecated",
        fields: deprecatedFields,
        failedChecker: (f) => _args.getValueByArgument(f) != null);
    return RequestParam.buildCheckResult([
      notAllowedChecker.check(),
      deprecatedChecker.check(),
    ]);
  }

  @override
  JsonMap toRpcJson() {
    JsonMap result = {}..addAll(fileInfo.toRpcJson());
    for (var f in allowedFields) {
      if (!toRpcJsonField(result, f)) {
        final val = _args.getValueByArgument(f);
        if (val == null) continue;
        result[f.argName] = toRpcJsonByType(val);
      }
    }
    return result;
  }

  bool toRpcJsonField(JsonMap result, TorrentAddArgument f) {
    switch (f) {
      case TorrentAddArgument.cookies:
        if (cookies != null) {
          result[f.argName] = cookies!.map((e) => e.toString()).join("; ");
        }
      case TorrentAddArgument.filename:
      case TorrentAddArgument.metainfo:
        break;
      default:
        return false;
    }
    return true;
  }
}

class _TorrentAddRequestParamRpc17 extends _TorrentAddRequestParam {
  static final _allowedFields = _TorrentAddRequestParam._allowedFields.union({
    TorrentAddArgument.labels,
  });

  _TorrentAddRequestParamRpc17({required super.args});

  @override
  Set<TorrentAddArgument> get allowedFields => _allowedFields;
}

class TorrentAdded {
  final TorrentId id;
  final String name;

  const TorrentAdded({
    required this.id,
    required this.name,
  });

  factory TorrentAdded.fromJson(JsonMap rawData) {
    return TorrentAdded(
      id: TorrentId(
          id: (rawData[TorrentGetArgument.id.argName] as num).toInt(),
          hashStr: rawData[TorrentGetArgument.hashString.argName] as String),
      name: rawData[TorrentGetArgument.name.argName] as String,
    );
  }
}

abstract class TorrentAddResponseParam implements ResponseParam {
  TorrentAdded? get torrent;
  bool get isDuplicated;

  const TorrentAddResponseParam();

  static final _verionBuilderMap =
      <ParamBuilderEntry1<TorrentAddResponseParam, JsonMap>>[
    MapEntry(15, (rawData) => _TorrentAddResponseParamRpc15.fromJson(rawData)),
  ];

  factory TorrentAddResponseParam.fromJson(JsonMap rawData,
          {ServerRpcVersion? version}) =>
      buildResponseParam1(version, rawData,
          nullVersionBuilder: (rawData) =>
              _TorrentAddResponseParam.fromJson(rawData),
          defaultVersionBuilder: (rawData) =>
              _TorrentAddResponseParam.fromJson(rawData),
          versionBuilers: _verionBuilderMap);
}

class _TorrentAddResponseParam extends TorrentAddResponseParam {
  final TorrentAdded? torrentAdded;

  const _TorrentAddResponseParam({this.torrentAdded});

  factory _TorrentAddResponseParam.fromJson(JsonMap rawData) {
    final rawTorrentAdded = rawData["torrent-added"];
    return _TorrentAddResponseParam(
        torrentAdded: rawTorrentAdded is JsonMap && rawTorrentAdded.isNotEmpty
            ? TorrentAdded.fromJson(rawTorrentAdded)
            : null);
  }

  @override
  bool get isDuplicated => false;

  @override
  TorrentAdded? get torrent => torrentAdded;
}

class _TorrentAddResponseParamRpc15 extends TorrentAddResponseParam {
  final TorrentAdded? torrentAdded;
  final TorrentAdded? torrentDulicate;

  const _TorrentAddResponseParamRpc15(
      {this.torrentAdded, this.torrentDulicate});

  factory _TorrentAddResponseParamRpc15.fromJson(JsonMap rawData) {
    final rawTorrentAdded = rawData["torrent-added"];
    final rawTorrentDuplicate = rawData["torrent-duplicate"];
    return _TorrentAddResponseParamRpc15(
      torrentAdded: rawTorrentAdded is JsonMap && rawTorrentAdded.isNotEmpty
          ? TorrentAdded.fromJson(rawTorrentAdded)
          : null,
      torrentDulicate:
          rawTorrentDuplicate is JsonMap && rawTorrentDuplicate.isNotEmpty
              ? TorrentAdded.fromJson(rawTorrentDuplicate)
              : null,
    );
  }

  @override
  bool get isDuplicated => torrentDulicate != null;

  @override
  TorrentAdded? get torrent => torrentDulicate ?? torrentAdded;
}
