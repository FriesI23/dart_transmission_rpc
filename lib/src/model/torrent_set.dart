// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: deprecated_member_use_from_same_package

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';
import 'torrent.dart';
import 'tracker_list.dart';

enum TorrentSetArgument {
  /// This torrent's bandwidth priority
  bandwidthPriority(argName: "bandwidthPriority"),

  /// Maximum download speed (KBps)
  downloadLimit(argName: "downloadLimit"),

  /// Indicates whether downloadLimit is honored
  downloadLimited(argName: "downloadLimited"),

  /// Indices of file(s) to not download
  filesUnwanted(argName: "files-unwanted"),

  /// Indices of file(s) to download
  filesWanted(argName: "files-wanted"),

  /// The name of this torrent's bandwidth group
  group(argName: "group"),

  /// Indicates whether session upload limits are honored
  honorsSessionLimits(argName: "honorsSessionLimits"),

  /// Torrent list, as described
  ids(argName: "ids"),

  /// Array of string labels
  labels(argName: "labels"),

  /// New location of the torrent's content
  location(argName: "location"),

  /// Maximum number of peers
  peerLimit(argName: "peer-limit"),

  /// Indices of high-priority file(s)
  priorityHigh(argName: "priority-high"),

  /// Indices of low-priority file(s)
  priorityLow(argName: "priority-low"),

  /// Indices of normal-priority file(s)
  priorityNormal(argName: "priority-normal"),

  /// Position of this torrent in its queue [0...n)
  queuePosition(argName: "queuePosition"),

  /// Torrent-level number of minutes of seeding inactivity
  seedIdleLimit(argName: "seedIdleLimit"),

  /// Which seeding inactivity to use
  seedIdleMode(argName: "seedIdleMode"),

  /// Torrent-level seeding ratio
  seedRatioLimit(argName: "seedRatioLimit"),

  /// Which ratio to use
  seedRatioMode(argName: "seedRatioMode"),

  /// Download torrent pieces sequentially
  sequentialDownload(argName: "sequentialDownload"),

  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  trackerAdd(argName: "trackerAdd"),

  /// String of announce URLs, one per line, and a blank line between tiers
  trackerList(argName: "trackerList"),

  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  trackerRemove(argName: "trackerRemove"),

  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  trackerReplace(argName: "trackerReplace"),

  /// Maximum upload speed (KBps)
  uploadLimit(argName: "uploadLimit"),

  /// Indicates whether uploadLimit is honored
  uploadLimited(argName: "uploadLimited");

  static final allFieldsSet = TorrentSetArgument.values.toSet();

  final String argName;

  const TorrentSetArgument({required this.argName});
}

class TrackerReplace {
  final TrackerId id;
  final String url;

  const TrackerReplace({required this.id, required this.url});

  List<dynamic> toRpcJson() => [id, url];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrackerReplace && other.id == id && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode;
}

mixin TorrentSetRequestArgsDefine {
  TorrentIds get ids;
  num? get bandwidthPriority;
  num? get downloadLimit;
  bool? get downloadLimited;
  FileIndices? get filesUnwanted;
  FileIndices? get filesWanted;
  bool? get honorsSessionLimits;
  String? get location;
  num? get peerLimit;
  FileIndices? get priorityHigh;
  FileIndices? get priorityLow;
  FileIndices? get priorityNormal;
  num? get queuePosition;
  num? get seedIdleLimit;
  IdleLimitMode? get seedIdleMode;
  num? get seedRatioLimit;
  RatioLimitMode? get seedRatioMode;
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<String>? get trackerAdd;
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<TrackerId>? get trackerRemove;
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<TrackerReplace>? get trackerReplace;
  num? get uploadLimit;
  bool? get uploadLimited;
  // rpc16 new
  List<String>? get labels;
  // rpc17 new
  String? get group;
  TrackerListIter? get trackerList;
  // rpc19 new
  bool? get sequentialDownload;
}

class TorrentSetRequestArgs with TorrentSetRequestArgsDefine {
  static final _enumToPropertyMap = {
    TorrentSetArgument.bandwidthPriority: (TorrentSetRequestArgs args) =>
        args.bandwidthPriority,
    TorrentSetArgument.downloadLimit: (TorrentSetRequestArgs args) =>
        args.downloadLimit,
    TorrentSetArgument.downloadLimited: (TorrentSetRequestArgs args) =>
        args.downloadLimited,
    TorrentSetArgument.filesUnwanted: (TorrentSetRequestArgs args) =>
        args.filesUnwanted,
    TorrentSetArgument.filesWanted: (TorrentSetRequestArgs args) =>
        args.filesWanted,
    TorrentSetArgument.group: (TorrentSetRequestArgs args) => args.group,
    TorrentSetArgument.honorsSessionLimits: (TorrentSetRequestArgs args) =>
        args.honorsSessionLimits,
    TorrentSetArgument.ids: (TorrentSetRequestArgs args) => args.ids,
    TorrentSetArgument.labels: (TorrentSetRequestArgs args) => args.labels,
    TorrentSetArgument.location: (TorrentSetRequestArgs args) => args.location,
    TorrentSetArgument.peerLimit: (TorrentSetRequestArgs args) =>
        args.peerLimit,
    TorrentSetArgument.priorityHigh: (TorrentSetRequestArgs args) =>
        args.priorityHigh,
    TorrentSetArgument.priorityLow: (TorrentSetRequestArgs args) =>
        args.priorityLow,
    TorrentSetArgument.priorityNormal: (TorrentSetRequestArgs args) =>
        args.priorityNormal,
    TorrentSetArgument.queuePosition: (TorrentSetRequestArgs args) =>
        args.queuePosition,
    TorrentSetArgument.seedIdleLimit: (TorrentSetRequestArgs args) =>
        args.seedIdleLimit,
    TorrentSetArgument.seedIdleMode: (TorrentSetRequestArgs args) =>
        args.seedIdleMode,
    TorrentSetArgument.seedRatioLimit: (TorrentSetRequestArgs args) =>
        args.seedRatioLimit,
    TorrentSetArgument.seedRatioMode: (TorrentSetRequestArgs args) =>
        args.seedRatioMode,
    TorrentSetArgument.sequentialDownload: (TorrentSetRequestArgs args) =>
        args.sequentialDownload,
    TorrentSetArgument.trackerAdd: (TorrentSetRequestArgs args) =>
        args.trackerAdd,
    TorrentSetArgument.trackerList: (TorrentSetRequestArgs args) =>
        args.trackerList,
    TorrentSetArgument.trackerRemove: (TorrentSetRequestArgs args) =>
        args.trackerRemove,
    TorrentSetArgument.trackerReplace: (TorrentSetRequestArgs args) =>
        args.trackerReplace,
    TorrentSetArgument.uploadLimit: (TorrentSetRequestArgs args) =>
        args.uploadLimit,
    TorrentSetArgument.uploadLimited: (TorrentSetRequestArgs args) =>
        args.uploadLimited,
  };

  @override
  final TorrentIds ids;
  @override
  final num? bandwidthPriority;
  @override
  final num? downloadLimit;
  @override
  final bool? downloadLimited;
  @override
  final FileIndices? filesUnwanted;
  @override
  final FileIndices? filesWanted;
  @override
  final bool? honorsSessionLimits;
  @override
  final String? location;
  @override
  final num? peerLimit;
  @override
  final FileIndices? priorityHigh;
  @override
  final FileIndices? priorityLow;
  @override
  final FileIndices? priorityNormal;
  @override
  final num? queuePosition;
  @override
  final num? seedIdleLimit;
  @override
  final IdleLimitMode? seedIdleMode;
  @override
  final num? seedRatioLimit;
  @override
  final RatioLimitMode? seedRatioMode;
  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  final List<String>? trackerAdd;
  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  final List<TrackerId>? trackerRemove;
  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  final List<TrackerReplace>? trackerReplace;
  @override
  final num? uploadLimit;
  @override
  final bool? uploadLimited;
  @override
  // rpc16 new
  final List<String>? labels;
  // rpc17 new
  @override
  final String? group;
  @override
  final TrackerListIter? trackerList;
  // rpc19 new
  @override
  final bool? sequentialDownload;

  const TorrentSetRequestArgs({
    required this.ids,
    this.bandwidthPriority,
    this.downloadLimit,
    this.downloadLimited,
    this.filesUnwanted,
    this.filesWanted,
    this.honorsSessionLimits,
    this.location,
    this.peerLimit,
    this.priorityHigh,
    this.priorityLow,
    this.priorityNormal,
    this.queuePosition,
    this.seedIdleLimit,
    this.seedIdleMode,
    this.seedRatioLimit,
    this.seedRatioMode,
    this.sequentialDownload,
    this.trackerAdd,
    this.trackerRemove,
    this.trackerReplace,
    this.uploadLimit,
    this.uploadLimited,
    this.labels,
    this.group,
    this.trackerList,
  });

  Object? getValueByArgument(TorrentSetArgument arg) =>
      _enumToPropertyMap[arg]?.call(this);
}

abstract class TorrentSetRequestParam
    with TorrentSetRequestArgsDefine
    implements RequestParam {
  final TorrentSetRequestArgs _args;

  @override
  TorrentIds get ids => _args.ids;

  @override
  num? get bandwidthPriority => _args.bandwidthPriority;

  @override
  num? get downloadLimit => _args.downloadLimit;

  @override
  bool? get downloadLimited => _args.downloadLimited;

  @override
  FileIndices? get filesUnwanted => _args.filesUnwanted;

  @override
  FileIndices? get filesWanted => _args.filesWanted;

  @override
  bool? get honorsSessionLimits => _args.honorsSessionLimits;

  @override
  String? get location => _args.location;

  @override
  num? get peerLimit => _args.peerLimit;

  @override
  FileIndices? get priorityHigh => _args.priorityHigh;

  @override
  FileIndices? get priorityLow => _args.priorityLow;

  @override
  FileIndices? get priorityNormal => _args.priorityNormal;

  @override
  num? get queuePosition => _args.queuePosition;

  @override
  num? get seedIdleLimit => _args.seedIdleLimit;

  @override
  IdleLimitMode? get seedIdleMode => _args.seedIdleMode;

  @override
  num? get seedRatioLimit => _args.seedRatioLimit;

  @override
  RatioLimitMode? get seedRatioMode => _args.seedRatioMode;

  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<String>? get trackerAdd => _args.trackerAdd;

  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<TrackerId>? get trackerRemove => _args.trackerRemove;

  @override
  @Deprecated("Deprecated rpc-version>=17, use \"trackerList\" instead")
  List<TrackerReplace>? get trackerReplace => _args.trackerReplace;

  @override
  num? get uploadLimit => _args.uploadLimit;

  @override
  bool? get uploadLimited => _args.uploadLimited;

  @override
  List<String>? get labels => _args.labels;

  @override
  String? get group => _args.group;

  @override
  TrackerListIter? get trackerList => _args.trackerList;

  @override
  bool? get sequentialDownload => _args.sequentialDownload;

  const TorrentSetRequestParam({required TorrentSetRequestArgs args})
      : _args = args;

  static final _verionBuilderMap =
      <ParamBuilderEntry1<TorrentSetRequestParam, TorrentSetRequestArgs>>[
    MapEntry(18, (args) => _TorrentSetRequestParamRpc18(args: args)),
    MapEntry(17, (args) => _TorrentSetRequestParamRpc17(args: args)),
    MapEntry(16, (args) => _TorrentSetRequestParamRpc16(args: args)),
  ];

  factory TorrentSetRequestParam.build(
          {ServerRpcVersion? version, required TorrentSetRequestArgs args}) =>
      buildRequestParam1(version, args,
          nullVersionBuilder: (args) => _TorrentSetRequestParam(args: args),
          defaultVersionBuilder: (args) => _TorrentSetRequestParam(args: args),
          versionBuilers: _verionBuilderMap);

  Set<TorrentSetArgument> get allowedFields;
  Set<TorrentSetArgument> get deprecatedFields;

  @override
  String? check() {
    final notAllowedChecker = RequestParamArgsChecker<TorrentSetArgument>(
        label: "$runtimeType.prohibited",
        fields: TorrentSetArgument.allFieldsSet.difference(allowedFields),
        failedChecker: (f) => _args.getValueByArgument(f) != null);
    final deprecatedChecker = RequestParamArgsChecker<TorrentSetArgument>(
        label: "$runtimeType.deprecated",
        fields: deprecatedFields,
        failedChecker: (f) => _args.getValueByArgument(f) != null);
    return RequestParam.buildCheckResult([
      notAllowedChecker.check(),
      deprecatedChecker.check(),
    ]);
  }
}

class _TorrentSetRequestParam extends TorrentSetRequestParam {
  static final _allowedFields = {
    TorrentSetArgument.bandwidthPriority,
    TorrentSetArgument.downloadLimit,
    TorrentSetArgument.downloadLimited,
    TorrentSetArgument.filesUnwanted,
    TorrentSetArgument.filesWanted,
    TorrentSetArgument.honorsSessionLimits,
    TorrentSetArgument.ids,
    TorrentSetArgument.location,
    TorrentSetArgument.peerLimit,
    TorrentSetArgument.priorityHigh,
    TorrentSetArgument.priorityLow,
    TorrentSetArgument.priorityNormal,
    TorrentSetArgument.queuePosition,
    TorrentSetArgument.seedIdleLimit,
    TorrentSetArgument.seedIdleMode,
    TorrentSetArgument.seedRatioLimit,
    TorrentSetArgument.seedRatioMode,
    TorrentSetArgument.uploadLimit,
    TorrentSetArgument.uploadLimited,
    TorrentSetArgument.trackerAdd,
    TorrentSetArgument.trackerRemove,
    TorrentSetArgument.trackerReplace,
  };

  const _TorrentSetRequestParam({required super.args});

  @override
  Set<TorrentSetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentSetArgument> get deprecatedFields => {};

  @override
  JsonMap toRpcJson() {
    JsonMap result = {};
    for (var f in allowedFields) {
      if (!toRpcJsonField(result, f)) {
        final val = _args.getValueByArgument(f);
        if (val == null) continue;
        result[f.argName] = toRpcJsonByType(val);
      }
    }
    return result;
  }

  bool toRpcJsonField(JsonMap result, TorrentSetArgument f) {
    switch (f) {
      case TorrentSetArgument.ids:
        if (ids.isNotEmpty) {
          result[f.argName] = ids.toRpcJson();
        }
      case TorrentSetArgument.trackerReplace:
        if (trackerReplace != null) {
          result[f.argName] =
              trackerReplace!.map((e) => e.toRpcJson()).toList();
        }
      default:
        return false;
    }
    return true;
  }
}

class _TorrentSetRequestParamRpc16 extends _TorrentSetRequestParam {
  static final _allowedFields = _TorrentSetRequestParam._allowedFields.union({
    TorrentSetArgument.labels,
  });

  const _TorrentSetRequestParamRpc16({required super.args});

  @override
  Set<TorrentSetArgument> get allowedFields => _allowedFields;

  @override
  bool toRpcJsonField(JsonMap result, TorrentSetArgument f) {
    switch (f) {
      case TorrentSetArgument.labels:
        if (labels != null) result[f.argName] = labels;
      default:
        return super.toRpcJsonField(result, f);
    }
    return true;
  }
}

class _TorrentSetRequestParamRpc17 extends _TorrentSetRequestParamRpc16 {
  static final _allowedFields =
      _TorrentSetRequestParamRpc16._allowedFields.union({
    TorrentSetArgument.group,
    TorrentSetArgument.trackerList,
  });

  static final _deprecatedFields = {
    TorrentSetArgument.trackerAdd,
    TorrentSetArgument.trackerRemove,
    TorrentSetArgument.trackerReplace,
  };

  const _TorrentSetRequestParamRpc17({required super.args});

  @override
  Set<TorrentSetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentSetArgument> get deprecatedFields => _deprecatedFields;

  @override
  bool toRpcJsonField(JsonMap result, TorrentSetArgument f) {
    switch (f) {
      case TorrentSetArgument.trackerList:
        if (trackerList != null) {
          result[f.argName] = trackerListCodec.encode(trackerList!);
        }
      default:
        return super.toRpcJsonField(result, f);
    }
    return true;
  }
}

class _TorrentSetRequestParamRpc18 extends _TorrentSetRequestParamRpc17 {
  static final _allowedFields =
      _TorrentSetRequestParamRpc17._allowedFields.union({
    TorrentSetArgument.sequentialDownload,
  });

  _TorrentSetRequestParamRpc18({required super.args});

  @override
  Set<TorrentSetArgument> get allowedFields => _allowedFields;
}

class TorrentSetResponseParam implements ResponseParam {
  const TorrentSetResponseParam();

  factory TorrentSetResponseParam.fromJson(JsonMap rawData) =>
      const TorrentSetResponseParam();
}
