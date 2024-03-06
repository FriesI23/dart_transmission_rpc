// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../exception.dart';
import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../version.dart';

enum SessionGetArgument {
  // max global download speed (KBps)
  altSpeedDown(argName: "alt-speed-down"),

  // true means use the alt speeds
  altSpeedEnabled(argName: "alt-speed-enabled"),

  // when to turn on alt speeds (units: minutes after midnight)
  altSpeedTimeBegin(argName: "alt-speed-time-begin"),

  // what day(s) to turn on alt speeds (look at tr_sched_day)
  altSpeedTimeDay(argName: "alt-speed-time-day"),

  // true means the scheduled on/off times are used
  altSpeedTimeEnabled(argName: "alt-speed-time-enabled"),

  // when to turn off alt speeds (units: same)
  altSpeedTimeEnd(argName: "alt-speed-time-end"),

  // max global upload speed (KBps)
  altSpeedUp(argName: "alt-speed-up"),

  // true means enabled
  blocklistEnabled(argName: "blocklist-enabled"),

  // number of rules in the blocklist
  blocklistSize(argName: "blocklist-size"),

  // location of the blocklist to use for `blocklist-update`
  blocklistUrl(argName: "blocklist-url"),

  // maximum size of the disk cache (MB)
  cacheSizeMb(argName: "cache-size-mb"),

  // location of transmission's configuration directory
  configDir(argName: "config-dir"),

  // announce URLs, one per line, and a blank line between tiers
  defaultTrackers(argName: "default-trackers"),

  // true means allow DHT in public torrents
  dhtEnabled(argName: "dht-enabled"),

  // default path to download torrents
  downloadDir(argName: "download-dir"),

  // DEPRECATED: Use the `free-space` method instead.
  downloadDirFreeSpace(argName: "download-dir-free-space"),

  // if true, limit how many torrents can be downloaded at once
  downloadQueueEnabled(argName: "download-queue-enabled"),

  // max number of torrents to download at once (see download-queue-enabled)
  downloadQueueSize(argName: "download-queue-size"),

  // `required`, `preferred`, `tolerated`
  encryption(argName: "encryption"),

  // true if the seeding inactivity limit is honored by default
  idleSeedingLimitEnabled(argName: "idle-seeding-limit-enabled"),

  // torrents we're seeding will be stopped if they're idle for this long
  idleSeedingLimit(argName: "idle-seeding-limit"),

  // true means keep torrents in incomplete-dir until done
  incompleteDirEnabled(argName: "incomplete-dir-enabled"),

  // path for incomplete torrents, when enabled
  incompleteDir(argName: "incomplete-dir"),

  // true means allow Local Peer Discovery in public torrents
  lpdEnabled(argName: "lpd-enabled"),

  // maximum global number of peers
  peerLimitGlobal(argName: "peer-limit-global"),

  // maximum global number of peers
  peerLimitPerTorrent(argName: "peer-limit-per-torrent"),

  // true means pick a random peer port on launch
  peerPortRandomOnStart(argName: "peer-port-random-on-start"),

  // port number
  peerPort(argName: "peer-port"),

  // true means allow PEX in public torrents
  pexEnabled(argName: "pex-enabled"),

  // true means ask upstream router to forward the configured peer port
  // to transmission using UPnP or NAT-PMP
  portForwardingEnabled(argName: "port-forwarding-enabled"),

  // whether or not to consider idle torrents as stalled
  queueStalledEnabled(argName: "queue-stalled-enabled"),

  // torrents that are idle for N minutes aren't counted
  // toward seed-queue-size or download-queue-size
  queueStalledMinutes(argName: "queue-stalled-minutes"),

  // true means append `.part` to incomplete files
  renamePartialFiles(argName: "rename-partial-files"),

  // the minimum RPC API version supported
  rpcVersionMinimum(argName: "rpc-version-minimum"),

  // the current RPC API version in a semver-compatible string
  rpcVersionSemver(argName: "rpc-version-semver"),

  // the current RPC API version
  rpcVersion(argName: "rpc-version"),

  // whether or not to call the `added` script
  scriptTorrentAddedEnabled(argName: "script-torrent-added-enabled"),

  // filename of the script to run
  scriptTorrentAddedFilename(argName: "script-torrent-added-filename"),

  // whether or not to call the `done` script
  scriptTorrentDoneEnabled(argName: "script-torrent-done-enabled"),

  // filename of the script to run
  scriptTorrentDoneFilename(argName: "script-torrent-done-filename"),

  // whether or not to call the `seeding-done` script
  scriptTorrentDoneSeedingEnabled(
      argName: "script-torrent-done-seeding-enabled"),

  // filename of the script to run
  scriptTorrentDoneSeedingFilename(
      argName: "script-torrent-done-seeding-filename"),

  // if true, limit how many torrents can be uploaded at once
  seedQueueEnabled(argName: "seed-queue-enabled"),

  // max number of torrents to upload at once (see seed-queue-enabled)
  seedQueueSize(argName: "seed-queue-size"),

  // the default seed ratio for torrents to use
  seedRatioLimit(argName: "seedRatioLimit"),

  // true if seedRatioLimit is honored by default
  seedRatioLimited(argName: "seedRatioLimited"),

  // the current `X-Transmission-Session-Id` value
  sessionId(argName: "session-id"),

  // true means enabled
  speedLimitDownEnabled(argName: "speed-limit-down-enabled"),

  // max global download speed (KBps)
  speedLimitDown(argName: "speed-limit-down"),

  // true means enabled
  speedLimitUpEnabled(argName: "speed-limit-up-enabled"),

  // max global upload speed (KBps)
  speedLimitUp(argName: "speed-limit-up"),

  // true means added torrents will be started right away
  startAddedTorrents(argName: "start-added-torrents"),

  // true means the .torrent file of added torrents will be deleted
  trashOriginalTorrentFiles(argName: "trash-original-torrent-files"),

  // see `SessionUnits` get more information
  units(argName: "units"),

  // true means allow UTP
  utpEnabled(argName: "utp-enabled"),

  // long version string `$version ($revision)`
  version(argName: "version");

  final String argName;

  const SessionGetArgument({required this.argName});
}

abstract class SessionGetRequestParam implements RequestParam {
  final List<SessionGetArgument>? fields;

  const SessionGetRequestParam(this.fields);

  factory SessionGetRequestParam.build(
      {ServerRpcVersion? version, List<SessionGetArgument>? fields}) {
    if (version == null) {
      return _SessionGetRequestParam(fields);
    } else if (version.checkApiVersionValidate(v: 17)) {
      return _SessionGetRequestPramRpc17(fields);
    } else if (version.checkApiVersionValidate(v: 16)) {
      return _SessionGetRequestPramRpc16(fields);
    } else if (version.checkApiVersionValidate()) {
      return _SessionGetRequestParam(fields);
    } else {
      throw TransmissionVersionError("Incompatible API version on session-get",
          version.rpcVersion, version.minRpcVersion);
    }
  }
}

class _SessionGetRequestParam extends SessionGetRequestParam {
  const _SessionGetRequestParam(super.fields);

  @override
  String? check() {
    if (fields != null) {
      return "fields support rpc version >= 16";
    }
    return null;
  }

  @override
  JsonMap toRpcJson() => {};
}

class _SessionGetRequestPramRpc16 extends SessionGetRequestParam {
  static const _allowedFields = {
    SessionGetArgument.altSpeedDown,
    SessionGetArgument.altSpeedEnabled,
    SessionGetArgument.altSpeedTimeBegin,
    SessionGetArgument.altSpeedTimeDay,
    SessionGetArgument.altSpeedTimeEnabled,
    SessionGetArgument.altSpeedTimeEnd,
    SessionGetArgument.altSpeedUp,
    SessionGetArgument.blocklistEnabled,
    SessionGetArgument.blocklistSize,
    SessionGetArgument.blocklistUrl,
    SessionGetArgument.cacheSizeMb,
    SessionGetArgument.configDir,
    SessionGetArgument.dhtEnabled,
    SessionGetArgument.downloadDir,
    SessionGetArgument.downloadDirFreeSpace,
    SessionGetArgument.downloadQueueEnabled,
    SessionGetArgument.downloadQueueSize,
    SessionGetArgument.encryption,
    SessionGetArgument.idleSeedingLimitEnabled,
    SessionGetArgument.idleSeedingLimit,
    SessionGetArgument.incompleteDirEnabled,
    SessionGetArgument.incompleteDir,
    SessionGetArgument.lpdEnabled,
    SessionGetArgument.peerLimitGlobal,
    SessionGetArgument.peerLimitPerTorrent,
    SessionGetArgument.peerPortRandomOnStart,
    SessionGetArgument.peerPort,
    SessionGetArgument.pexEnabled,
    SessionGetArgument.portForwardingEnabled,
    SessionGetArgument.queueStalledEnabled,
    SessionGetArgument.queueStalledMinutes,
    SessionGetArgument.renamePartialFiles,
    SessionGetArgument.rpcVersionMinimum,
    SessionGetArgument.rpcVersion,
    SessionGetArgument.scriptTorrentDoneEnabled,
    SessionGetArgument.scriptTorrentDoneFilename,
    SessionGetArgument.seedQueueEnabled,
    SessionGetArgument.seedQueueSize,
    SessionGetArgument.seedRatioLimit,
    SessionGetArgument.seedRatioLimited,
    SessionGetArgument.sessionId,
    SessionGetArgument.speedLimitDownEnabled,
    SessionGetArgument.speedLimitDown,
    SessionGetArgument.speedLimitUpEnabled,
    SessionGetArgument.speedLimitUp,
    SessionGetArgument.startAddedTorrents,
    SessionGetArgument.trashOriginalTorrentFiles,
    SessionGetArgument.units,
    SessionGetArgument.utpEnabled,
    SessionGetArgument.version,
  };

  const _SessionGetRequestPramRpc16(super.fields);

  Set<SessionGetArgument> get allowedFields => _allowedFields;
  Set<SessionGetArgument> get deprecatedFields => {};

  @override
  String? check() {
    if (fields == null) return null;
    final Set<SessionGetArgument> mFields = {};
    final Set<SessionGetArgument> dFields = {};
    for (var f in fields!) {
      if (!allowedFields.contains(f)) mFields.add(f);
      if (deprecatedFields.contains(f)) dFields.add(f);
    }
    if (mFields.isNotEmpty || dFields.isNotEmpty) {
      return "got possibly imcompatible fields, "
          "missing: $mFields, deprecated: $dFields";
    }
    return null;
  }

  @override
  JsonMap toRpcJson() => {
        if (fields != null)
          "fields": fields!
              .where((e) => allowedFields.contains(e))
              .map((e) => e.argName)
              .toList(),
      };
}

class _SessionGetRequestPramRpc17 extends _SessionGetRequestPramRpc16 {
  static const _allowedFields = {
    SessionGetArgument.altSpeedDown,
    SessionGetArgument.altSpeedEnabled,
    SessionGetArgument.altSpeedTimeBegin,
    SessionGetArgument.altSpeedTimeDay,
    SessionGetArgument.altSpeedTimeEnabled,
    SessionGetArgument.altSpeedTimeEnd,
    SessionGetArgument.altSpeedUp,
    SessionGetArgument.blocklistEnabled,
    SessionGetArgument.blocklistSize,
    SessionGetArgument.blocklistUrl,
    SessionGetArgument.cacheSizeMb,
    SessionGetArgument.configDir,
    SessionGetArgument.defaultTrackers, // new arg
    SessionGetArgument.dhtEnabled,
    SessionGetArgument.downloadDir,
    SessionGetArgument.downloadDirFreeSpace,
    SessionGetArgument.downloadQueueEnabled,
    SessionGetArgument.downloadQueueSize,
    SessionGetArgument.encryption,
    SessionGetArgument.idleSeedingLimitEnabled,
    SessionGetArgument.idleSeedingLimit,
    SessionGetArgument.incompleteDirEnabled,
    SessionGetArgument.incompleteDir,
    SessionGetArgument.lpdEnabled,
    SessionGetArgument.peerLimitGlobal,
    SessionGetArgument.peerLimitPerTorrent,
    SessionGetArgument.peerPortRandomOnStart,
    SessionGetArgument.peerPort,
    SessionGetArgument.pexEnabled,
    SessionGetArgument.portForwardingEnabled,
    SessionGetArgument.queueStalledEnabled,
    SessionGetArgument.queueStalledMinutes,
    SessionGetArgument.renamePartialFiles,
    SessionGetArgument.rpcVersionMinimum, // new arg
    SessionGetArgument.rpcVersionSemver,
    SessionGetArgument.rpcVersion,
    SessionGetArgument.scriptTorrentAddedEnabled, // new arg
    SessionGetArgument.scriptTorrentAddedFilename, // new arg
    SessionGetArgument.scriptTorrentDoneEnabled,
    SessionGetArgument.scriptTorrentDoneFilename,
    SessionGetArgument.scriptTorrentDoneSeedingEnabled, // new arg
    SessionGetArgument.scriptTorrentDoneSeedingFilename, // new arg
    SessionGetArgument.seedQueueEnabled,
    SessionGetArgument.seedQueueSize,
    SessionGetArgument.seedRatioLimit,
    SessionGetArgument.seedRatioLimited,
    SessionGetArgument.sessionId,
    SessionGetArgument.speedLimitDownEnabled,
    SessionGetArgument.speedLimitDown,
    SessionGetArgument.speedLimitUpEnabled,
    SessionGetArgument.speedLimitUp,
    SessionGetArgument.startAddedTorrents,
    SessionGetArgument.trashOriginalTorrentFiles,
    SessionGetArgument.units,
    SessionGetArgument.utpEnabled,
    SessionGetArgument.version,
  };
  static const _deprecatedFields = {
    SessionGetArgument.downloadDirFreeSpace,
  };

  const _SessionGetRequestPramRpc17(super.fields);

  @override
  Set<SessionGetArgument> get allowedFields => _allowedFields;

  @override
  Set<SessionGetArgument> get deprecatedFields => _deprecatedFields;
}

class SessionUnits {
  final List<String> speedUnits;
  final num speedBytes;
  final List<String> sizeUnits;
  final num sizeBytes;
  final List<String> memoryUnits;
  final num memoryBytes;

  const SessionUnits({
    required this.speedUnits,
    required this.speedBytes,
    required this.sizeUnits,
    required this.sizeBytes,
    required this.memoryUnits,
    required this.memoryBytes,
  });

  factory SessionUnits.fromJson(JsonMap rawData) {
    return SessionUnits(
      speedUnits: rawData["speed-units"].cast<String>(),
      speedBytes: rawData["speed-bytes"] as num,
      sizeUnits: rawData["size-units"].cast<String>(),
      sizeBytes: rawData["size-bytes"] as num,
      memoryUnits: rawData["memory-units"].cast<String>(),
      memoryBytes: rawData["memory-bytes"] as num,
    );
  }
}

class SessionGetResponseParam implements ResponseParam {
  final num? altSpeedDown;
  final bool? altSpeedEnabled;
  final num? altSpeedTimeBegin;
  final num? altSpeedTimeDay;
  final bool? altSpeedTimeEnabled;
  final num? altSpeedTimeEnd;
  final num? altSpeedUp;
  final bool? blocklistEnabled;
  final num? blocklistSize;
  final String? blocklistUrl;
  final num? cacheSizeMb;
  final String? configDir;
  final String? defaultTrackers;
  final bool? dhtEnabled;
  final String? downloadDir;
  @Deprecated("deprecated rpc-version>=17")
  final num? downloadDirFreeSpace;
  final bool? downloadQueueEnabled;
  final num? downloadQueueSize;
  final String? encryption;
  final bool? idleSeedingLimitEnabled;
  final num? idleSeedingLimit;
  final bool? incompleteDirEnabled;
  final String? incompleteDir;
  final bool? lpdEnabled;
  final num? peerLimitGlobal;
  final num? peerLimitPerTorrent;
  final bool? peerPortRandomOnStart;
  final num? peerPort;
  final bool? pexEnabled;
  final bool? portForwardingEnabled;
  final bool? queueStalledEnabled;
  final num? queueStalledMinutes;
  final bool? renamePartialFiles;
  final num? rpcVersionMinimum;
  final String? rpcVersionSemver;
  final num? rpcVersion;
  final bool? scriptTorrentAddedEnabled;
  final String? scriptTorrentAddedFilename;
  final bool? scriptTorrentDoneEnabled;
  final String? scriptTorrentDoneFilename;
  final bool? scriptTorrentDoneSeedingEnabled;
  final String? scriptTorrentDoneSeedingFilename;
  final bool? seedQueueEnabled;
  final num? seedQueueSize;
  final num? seedRatioLimit;
  final bool? seedRatioLimited;
  final String? sessionId;
  final bool? speedLimitDownEnabled;
  final num? speedLimitDown;
  final bool? speedLimitUpEnabled;
  final num? speedLimitUp;
  final bool? startAddedTorrents;
  final bool? trashOriginalTorrentFiles;
  final SessionUnits? units;
  final bool? utpEnabled;
  final String? version;

  SessionGetResponseParam({
    this.altSpeedDown,
    this.altSpeedEnabled,
    this.altSpeedTimeBegin,
    this.altSpeedTimeDay,
    this.altSpeedTimeEnabled,
    this.altSpeedTimeEnd,
    this.altSpeedUp,
    this.blocklistEnabled,
    this.blocklistSize,
    this.blocklistUrl,
    this.cacheSizeMb,
    this.configDir,
    this.defaultTrackers,
    this.dhtEnabled,
    this.downloadDir,
    this.downloadDirFreeSpace,
    this.downloadQueueEnabled,
    this.downloadQueueSize,
    this.encryption,
    this.idleSeedingLimitEnabled,
    this.idleSeedingLimit,
    this.incompleteDirEnabled,
    this.incompleteDir,
    this.lpdEnabled,
    this.peerLimitGlobal,
    this.peerLimitPerTorrent,
    this.peerPortRandomOnStart,
    this.peerPort,
    this.pexEnabled,
    this.portForwardingEnabled,
    this.queueStalledEnabled,
    this.queueStalledMinutes,
    this.renamePartialFiles,
    this.rpcVersionMinimum,
    this.rpcVersionSemver,
    this.rpcVersion,
    this.scriptTorrentAddedEnabled,
    this.scriptTorrentAddedFilename,
    this.scriptTorrentDoneEnabled,
    this.scriptTorrentDoneFilename,
    this.scriptTorrentDoneSeedingEnabled,
    this.scriptTorrentDoneSeedingFilename,
    this.seedQueueEnabled,
    this.seedQueueSize,
    this.seedRatioLimit,
    this.seedRatioLimited,
    this.sessionId,
    this.speedLimitDownEnabled,
    this.speedLimitDown,
    this.speedLimitUpEnabled,
    this.speedLimitUp,
    this.startAddedTorrents,
    this.trashOriginalTorrentFiles,
    this.units,
    this.utpEnabled,
    this.version,
  });

  factory SessionGetResponseParam.fromJson(JsonMap rawData) {
    final rawUnits = rawData[SessionGetArgument.units.argName];
    final units =
        (rawUnits is JsonMap) ? SessionUnits.fromJson(rawUnits) : null;
    return SessionGetResponseParam(
      version: rawData[SessionGetArgument.version.argName] as String?,
      altSpeedDown: rawData[SessionGetArgument.altSpeedDown.argName] as num?,
      altSpeedEnabled:
          rawData[SessionGetArgument.altSpeedEnabled.argName] as bool?,
      altSpeedTimeBegin:
          rawData[SessionGetArgument.altSpeedTimeBegin.argName] as num?,
      altSpeedTimeDay:
          rawData[SessionGetArgument.altSpeedTimeDay.argName] as num?,
      altSpeedTimeEnabled:
          rawData[SessionGetArgument.altSpeedTimeEnabled.argName] as bool?,
      altSpeedTimeEnd:
          rawData[SessionGetArgument.altSpeedTimeEnd.argName] as num?,
      altSpeedUp: rawData[SessionGetArgument.altSpeedUp.argName] as num?,
      blocklistEnabled:
          rawData[SessionGetArgument.blocklistEnabled.argName] as bool?,
      blocklistSize: rawData[SessionGetArgument.blocklistSize.argName] as num?,
      blocklistUrl: rawData[SessionGetArgument.blocklistUrl.argName] as String?,
      cacheSizeMb: rawData[SessionGetArgument.cacheSizeMb.argName] as num?,
      configDir: rawData[SessionGetArgument.configDir.argName] as String?,
      defaultTrackers:
          rawData[SessionGetArgument.defaultTrackers.argName] as String?,
      dhtEnabled: rawData[SessionGetArgument.dhtEnabled.argName] as bool?,
      downloadDir: rawData[SessionGetArgument.downloadDir.argName] as String?,
      downloadDirFreeSpace:
          rawData[SessionGetArgument.downloadDirFreeSpace.argName] as num?,
      downloadQueueEnabled:
          rawData[SessionGetArgument.downloadQueueEnabled.argName] as bool?,
      downloadQueueSize:
          rawData[SessionGetArgument.downloadQueueSize.argName] as num?,
      encryption: rawData[SessionGetArgument.encryption.argName] as String?,
      idleSeedingLimitEnabled:
          rawData[SessionGetArgument.idleSeedingLimitEnabled.argName] as bool?,
      idleSeedingLimit:
          rawData[SessionGetArgument.idleSeedingLimit.argName] as num?,
      incompleteDirEnabled:
          rawData[SessionGetArgument.incompleteDirEnabled.argName] as bool?,
      incompleteDir:
          rawData[SessionGetArgument.incompleteDir.argName] as String?,
      lpdEnabled: rawData[SessionGetArgument.lpdEnabled.argName] as bool?,
      peerLimitGlobal:
          rawData[SessionGetArgument.peerLimitGlobal.argName] as num?,
      peerLimitPerTorrent:
          rawData[SessionGetArgument.peerLimitPerTorrent.argName] as num?,
      peerPortRandomOnStart:
          rawData[SessionGetArgument.peerPortRandomOnStart.argName] as bool?,
      peerPort: rawData[SessionGetArgument.peerPort.argName] as num?,
      pexEnabled: rawData[SessionGetArgument.pexEnabled.argName] as bool?,
      portForwardingEnabled:
          rawData[SessionGetArgument.portForwardingEnabled.argName] as bool?,
      queueStalledEnabled:
          rawData[SessionGetArgument.queueStalledEnabled.argName] as bool?,
      queueStalledMinutes:
          rawData[SessionGetArgument.queueStalledMinutes.argName] as num?,
      renamePartialFiles:
          rawData[SessionGetArgument.renamePartialFiles.argName] as bool?,
      rpcVersionMinimum:
          rawData[SessionGetArgument.rpcVersionMinimum.argName] as num?,
      rpcVersionSemver:
          rawData[SessionGetArgument.rpcVersionSemver.argName] as String?,
      rpcVersion: rawData[SessionGetArgument.rpcVersion.argName] as num?,
      scriptTorrentAddedEnabled:
          rawData[SessionGetArgument.scriptTorrentAddedEnabled.argName]
              as bool?,
      scriptTorrentAddedFilename:
          rawData[SessionGetArgument.scriptTorrentAddedFilename.argName]
              as String?,
      scriptTorrentDoneEnabled:
          rawData[SessionGetArgument.scriptTorrentDoneEnabled.argName] as bool?,
      scriptTorrentDoneFilename:
          rawData[SessionGetArgument.scriptTorrentDoneFilename.argName]
              as String?,
      scriptTorrentDoneSeedingEnabled:
          rawData[SessionGetArgument.scriptTorrentDoneSeedingEnabled.argName]
              as bool?,
      scriptTorrentDoneSeedingFilename:
          rawData[SessionGetArgument.scriptTorrentDoneSeedingFilename.argName]
              as String?,
      seedQueueEnabled:
          rawData[SessionGetArgument.seedQueueEnabled.argName] as bool?,
      seedQueueSize: rawData[SessionGetArgument.seedQueueSize.argName] as num?,
      seedRatioLimit: rawData[SessionGetArgument.seedRatioLimit.argName],
      seedRatioLimited:
          rawData[SessionGetArgument.seedRatioLimited.argName] as bool?,
      sessionId: rawData[SessionGetArgument.sessionId.argName] as String?,
      speedLimitDownEnabled:
          rawData[SessionGetArgument.speedLimitDownEnabled.argName] as bool?,
      speedLimitDown:
          rawData[SessionGetArgument.speedLimitDown.argName] as num?,
      speedLimitUpEnabled:
          rawData[SessionGetArgument.speedLimitUpEnabled.argName] as bool?,
      speedLimitUp: rawData[SessionGetArgument.speedLimitUp.argName] as num?,
      startAddedTorrents:
          rawData[SessionGetArgument.startAddedTorrents.argName] as bool?,
      trashOriginalTorrentFiles:
          rawData[SessionGetArgument.trashOriginalTorrentFiles.argName]
              as bool?,
      units: units,
      utpEnabled: rawData[SessionGetArgument.utpEnabled.argName] as bool?,
    );
  }
}
