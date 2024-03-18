// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';

enum SessionSetArgument {
  /// max global download speed (KBps)
  altSpeedDown(argName: "alt-speed-down"),

  /// true means use the alt speeds
  altSpeedEnabled(argName: "alt-speed-enabled"),

  /// when to turn on alt speeds (units: minutes after midnight)
  altSpeedTimeBegin(argName: "alt-speed-time-begin"),

  /// what day(s) to turn on alt speeds (look at tr_sched_day)
  altSpeedTimeDay(argName: "alt-speed-time-day"),

  /// true means the scheduled on/off times are used
  altSpeedTimeEnabled(argName: "alt-speed-time-enabled"),

  /// when to turn off alt speeds (units: same)
  altSpeedTimeEnd(argName: "alt-speed-time-end"),

  /// max global upload speed (KBps)
  altSpeedUp(argName: "alt-speed-up"),

  /// true means enabled
  blocklistEnabled(argName: "blocklist-enabled"),

  /// location of the blocklist to use for `blocklist-update`
  blocklistUrl(argName: "blocklist-url"),

  /// maximum size of the disk cache (MB)
  cacheSizeMb(argName: "cache-size-mb"),

  /// announce URLs, one per line, and a blank line between tiers
  defaultTrackers(argName: "default-trackers"),

  /// true means allow DHT in public torrents
  dhtEnabled(argName: "dht-enabled"),

  /// default path to download torrents
  downloadDir(argName: "download-dir"),

  /// DEPRECATED: Use the `free-space` method instead.
  downloadDirFreeSpace(argName: "download-dir-free-space"),

  /// if true, limit how many torrents can be downloaded at once
  downloadQueueEnabled(argName: "download-queue-enabled"),

  /// max number of torrents to download at once (see download-queue-enabled)
  downloadQueueSize(argName: "download-queue-size"),

  /// `required`, `preferred`, `tolerated`
  encryption(argName: "encryption"),

  /// true if the seeding inactivity limit is honored by default
  idleSeedingLimitEnabled(argName: "idle-seeding-limit-enabled"),

  /// torrents we're seeding will be stopped if they're idle for this long
  idleSeedingLimit(argName: "idle-seeding-limit"),

  /// true means keep torrents in incomplete-dir until done
  incompleteDirEnabled(argName: "incomplete-dir-enabled"),

  /// path for incomplete torrents, when enabled
  incompleteDir(argName: "incomplete-dir"),

  /// true means allow Local Peer Discovery in public torrents
  lpdEnabled(argName: "lpd-enabled"),

  /// maximum global number of peers
  peerLimitGlobal(argName: "peer-limit-global"),

  /// maximum global number of peers
  peerLimitPerTorrent(argName: "peer-limit-per-torrent"),

  /// true means pick a random peer port on launch
  peerPortRandomOnStart(argName: "peer-port-random-on-start"),

  /// port number
  peerPort(argName: "peer-port"),

  /// true means allow PEX in public torrents
  pexEnabled(argName: "pex-enabled"),

  /// true means ask upstream router to forward the configured peer port
  /// to transmission using UPnP or NAT-PMP
  portForwardingEnabled(argName: "port-forwarding-enabled"),

  /// whether or not to consider idle torrents as stalled
  queueStalledEnabled(argName: "queue-stalled-enabled"),

  /// torrents that are idle for N minutes aren't counted
  /// toward seed-queue-size or download-queue-size
  queueStalledMinutes(argName: "queue-stalled-minutes"),

  /// true means append `.part` to incomplete files
  renamePartialFiles(argName: "rename-partial-files"),

  /// whether or not to call the `added` script
  scriptTorrentAddedEnabled(argName: "script-torrent-added-enabled"),

  /// filename of the script to run
  scriptTorrentAddedFilename(argName: "script-torrent-added-filename"),

  /// whether or not to call the `done` script
  scriptTorrentDoneEnabled(argName: "script-torrent-done-enabled"),

  /// filename of the script to run
  scriptTorrentDoneFilename(argName: "script-torrent-done-filename"),

  /// whether or not to call the `seeding-done` script
  scriptTorrentDoneSeedingEnabled(
      argName: "script-torrent-done-seeding-enabled"),

  /// filename of the script to run
  scriptTorrentDoneSeedingFilename(
      argName: "script-torrent-done-seeding-filename"),

  /// if true, limit how many torrents can be uploaded at once
  seedQueueEnabled(argName: "seed-queue-enabled"),

  /// max number of torrents to upload at once (see seed-queue-enabled)
  seedQueueSize(argName: "seed-queue-size"),

  /// the default seed ratio for torrents to use
  seedRatioLimit(argName: "seedRatioLimit"),

  /// true if seedRatioLimit is honored by default
  seedRatioLimited(argName: "seedRatioLimited"),

  /// true means enabled
  speedLimitDownEnabled(argName: "speed-limit-down-enabled"),

  /// max global download speed (KBps)
  speedLimitDown(argName: "speed-limit-down"),

  /// true means enabled
  speedLimitUpEnabled(argName: "speed-limit-up-enabled"),

  /// max global upload speed (KBps)
  speedLimitUp(argName: "speed-limit-up"),

  /// true means added torrents will be started right away
  startAddedTorrents(argName: "start-added-torrents"),

  /// true means the .torrent file of added torrents will be deleted
  trashOriginalTorrentFiles(argName: "trash-original-torrent-files"),

  /// true means allow UTP
  utpEnabled(argName: "utp-enabled");

  final String argName;

  const SessionSetArgument({required this.argName});
}

mixin SessionSetRequestArgsDefine {
  num? get altSpeedDown;
  bool? get altSpeedEnabled;
  num? get altSpeedTimeBegin;
  num? get altSpeedTimeDay;
  bool? get altSpeedTimeEnabled;
  num? get altSpeedTimeEnd;
  num? get altSpeedUp;
  bool? get blocklistEnabled;
  String? get blocklistUrl;
  num? get cacheSizeMb;
  String? get defaultTrackers;
  bool? get dhtEnabled;
  String? get downloadDir;
  num? get downloadDirFreeSpace;
  bool? get downloadQueueEnabled;
  num? get downloadQueueSize;
  String? get encryption;
  bool? get idleSeedingLimitEnabled;
  num? get idleSeedingLimit;
  bool? get incompleteDirEnabled;
  String? get incompleteDir;
  bool? get lpdEnabled;
  num? get peerLimitGlobal;
  num? get peerLimitPerTorrent;
  bool? get peerPortRandomOnStart;
  num? get peerPort;
  bool? get pexEnabled;
  bool? get portForwardingEnabled;
  bool? get queueStalledEnabled;
  num? get queueStalledMinutes;
  bool? get renamePartialFiles;
  bool? get scriptTorrentAddedEnabled;
  String? get scriptTorrentAddedFilename;
  bool? get scriptTorrentDoneEnabled;
  String? get scriptTorrentDoneFilename;
  bool? get scriptTorrentDoneSeedingEnabled;
  String? get scriptTorrentDoneSeedingFilename;
  bool? get seedQueueEnabled;
  num? get seedQueueSize;
  num? get seedRatioLimit;
  bool? get seedRatioLimited;
  bool? get speedLimitDownEnabled;
  num? get speedLimitDown;
  bool? get speedLimitUpEnabled;
  num? get speedLimitUp;
  bool? get startAddedTorrents;
  bool? get trashOriginalTorrentFiles;
  bool? get utpEnabled;
}

class SessionSetRequestArgs with SessionSetRequestArgsDefine {
  @override
  final num? altSpeedDown;
  @override
  final bool? altSpeedEnabled;
  @override
  final num? altSpeedTimeBegin;
  @override
  final num? altSpeedTimeDay;
  @override
  final bool? altSpeedTimeEnabled;
  @override
  final num? altSpeedTimeEnd;
  @override
  final num? altSpeedUp;
  @override
  final bool? blocklistEnabled;
  @override
  final String? blocklistUrl;
  @override
  final num? cacheSizeMb;
  @override
  final String? defaultTrackers;
  @override
  final bool? dhtEnabled;
  @override
  final String? downloadDir;
  @override
  final num? downloadDirFreeSpace;
  @override
  final bool? downloadQueueEnabled;
  @override
  final num? downloadQueueSize;
  @override
  final String? encryption;
  @override
  final bool? idleSeedingLimitEnabled;
  @override
  final num? idleSeedingLimit;
  @override
  final bool? incompleteDirEnabled;
  @override
  final String? incompleteDir;
  @override
  final bool? lpdEnabled;
  @override
  final num? peerLimitGlobal;
  @override
  final num? peerLimitPerTorrent;
  @override
  final bool? peerPortRandomOnStart;
  @override
  final num? peerPort;
  @override
  final bool? pexEnabled;
  @override
  final bool? portForwardingEnabled;
  @override
  final bool? queueStalledEnabled;
  @override
  final num? queueStalledMinutes;
  @override
  final bool? renamePartialFiles;
  @override
  final bool? scriptTorrentAddedEnabled;
  @override
  final String? scriptTorrentAddedFilename;
  @override
  final bool? scriptTorrentDoneEnabled;
  @override
  final String? scriptTorrentDoneFilename;
  @override
  final bool? scriptTorrentDoneSeedingEnabled;
  @override
  final String? scriptTorrentDoneSeedingFilename;
  @override
  final bool? seedQueueEnabled;
  @override
  final num? seedQueueSize;
  @override
  final num? seedRatioLimit;
  @override
  final bool? seedRatioLimited;
  @override
  final bool? speedLimitDownEnabled;
  @override
  final num? speedLimitDown;
  @override
  final bool? speedLimitUpEnabled;
  @override
  final num? speedLimitUp;
  @override
  final bool? startAddedTorrents;
  @override
  final bool? trashOriginalTorrentFiles;
  @override
  final bool? utpEnabled;

  const SessionSetRequestArgs({
    this.altSpeedDown,
    this.altSpeedEnabled,
    this.altSpeedTimeBegin,
    this.altSpeedTimeDay,
    this.altSpeedTimeEnabled,
    this.altSpeedTimeEnd,
    this.altSpeedUp,
    this.blocklistEnabled,
    this.blocklistUrl,
    this.cacheSizeMb,
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
    this.speedLimitDownEnabled,
    this.speedLimitDown,
    this.speedLimitUpEnabled,
    this.speedLimitUp,
    this.startAddedTorrents,
    this.trashOriginalTorrentFiles,
    this.utpEnabled,
  });
}

abstract class SessionSetRequestParam
    with SessionSetRequestArgsDefine
    implements RequestParam {
  final SessionSetRequestArgs _args;

  @override
  num? get altSpeedDown => _args.altSpeedDown;

  @override
  bool? get altSpeedEnabled => _args.altSpeedEnabled;

  @override
  num? get altSpeedTimeBegin => _args.altSpeedTimeBegin;

  @override
  num? get altSpeedTimeDay => _args.altSpeedTimeDay;

  @override
  bool? get altSpeedTimeEnabled => _args.altSpeedTimeEnabled;

  @override
  num? get altSpeedTimeEnd => _args.altSpeedTimeEnd;

  @override
  num? get altSpeedUp => _args.altSpeedUp;

  @override
  bool? get blocklistEnabled => _args.blocklistEnabled;

  @override
  String? get blocklistUrl => _args.blocklistUrl;

  @override
  num? get cacheSizeMb => _args.cacheSizeMb;

  @override
  String? get defaultTrackers => _args.defaultTrackers;

  @override
  bool? get dhtEnabled => _args.dhtEnabled;

  @override
  String? get downloadDir => _args.downloadDir;

  @override
  num? get downloadDirFreeSpace => _args.downloadDirFreeSpace;

  @override
  bool? get downloadQueueEnabled => _args.downloadQueueEnabled;

  @override
  num? get downloadQueueSize => _args.downloadQueueSize;

  @override
  String? get encryption => _args.encryption;

  @override
  num? get idleSeedingLimit => _args.idleSeedingLimit;

  @override
  bool? get idleSeedingLimitEnabled => _args.idleSeedingLimitEnabled;

  @override
  String? get incompleteDir => _args.incompleteDir;

  @override
  bool? get incompleteDirEnabled => _args.incompleteDirEnabled;

  @override
  bool? get lpdEnabled => _args.lpdEnabled;

  @override
  num? get peerLimitGlobal => _args.peerLimitGlobal;

  @override
  num? get peerLimitPerTorrent => _args.peerLimitPerTorrent;

  @override
  num? get peerPort => _args.peerPort;

  @override
  bool? get peerPortRandomOnStart => _args.peerPortRandomOnStart;

  @override
  bool? get pexEnabled => _args.pexEnabled;

  @override
  bool? get portForwardingEnabled => _args.portForwardingEnabled;

  @override
  bool? get queueStalledEnabled => _args.queueStalledEnabled;

  @override
  num? get queueStalledMinutes => _args.queueStalledMinutes;

  @override
  bool? get renamePartialFiles => _args.renamePartialFiles;

  @override
  bool? get scriptTorrentAddedEnabled => _args.scriptTorrentAddedEnabled;

  @override
  String? get scriptTorrentAddedFilename => _args.scriptTorrentAddedFilename;

  @override
  bool? get scriptTorrentDoneEnabled => _args.scriptTorrentDoneEnabled;

  @override
  String? get scriptTorrentDoneFilename => _args.scriptTorrentDoneFilename;

  @override
  bool? get scriptTorrentDoneSeedingEnabled =>
      _args.scriptTorrentDoneSeedingEnabled;

  @override
  String? get scriptTorrentDoneSeedingFilename =>
      _args.scriptTorrentDoneSeedingFilename;

  @override
  bool? get seedQueueEnabled => _args.seedQueueEnabled;

  @override
  num? get seedQueueSize => _args.seedQueueSize;

  @override
  num? get seedRatioLimit => _args.seedRatioLimit;

  @override
  bool? get seedRatioLimited => _args.seedRatioLimited;

  @override
  num? get speedLimitDown => _args.speedLimitDown;

  @override
  bool? get speedLimitDownEnabled => _args.speedLimitDownEnabled;

  @override
  num? get speedLimitUp => _args.speedLimitUp;

  @override
  bool? get speedLimitUpEnabled => _args.speedLimitUpEnabled;

  @override
  bool? get startAddedTorrents => _args.startAddedTorrents;

  @override
  bool? get trashOriginalTorrentFiles => _args.trashOriginalTorrentFiles;

  @override
  bool? get utpEnabled => _args.utpEnabled;

  const SessionSetRequestParam({required SessionSetRequestArgs args})
      : _args = args;

  factory SessionSetRequestParam.build({
    ServerRpcVersion? version,
    SessionSetRequestArgs? args,
  }) =>
      buildRequestParam1(version, args,
          nullVersionBuilder: (args) => _SessionSetRequestParam(
              args: args ?? const SessionSetRequestArgs()),
          defaultVersionBuilder: (args) => _SessionSetRequestParam(
              args: args ?? const SessionSetRequestArgs()));
}

class _SessionSetRequestParam extends SessionSetRequestParam {
  const _SessionSetRequestParam({required super.args});

  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() {
    return {
      if (altSpeedDown != null)
        SessionSetArgument.altSpeedDown.argName: altSpeedDown,
      if (altSpeedEnabled != null)
        SessionSetArgument.altSpeedEnabled.argName: altSpeedEnabled,
      if (altSpeedTimeBegin != null)
        SessionSetArgument.altSpeedTimeBegin.argName: altSpeedTimeBegin,
      if (altSpeedTimeDay != null)
        SessionSetArgument.altSpeedTimeDay.argName: altSpeedTimeDay,
      if (altSpeedTimeEnabled != null)
        SessionSetArgument.altSpeedTimeEnabled.argName: altSpeedTimeEnabled,
      if (altSpeedTimeEnd != null)
        SessionSetArgument.altSpeedTimeEnd.argName: altSpeedTimeEnd,
      if (altSpeedUp != null) SessionSetArgument.altSpeedUp.argName: altSpeedUp,
      if (blocklistEnabled != null)
        SessionSetArgument.blocklistEnabled.argName: blocklistEnabled,
      if (blocklistUrl != null)
        SessionSetArgument.blocklistUrl.argName: blocklistUrl,
      if (cacheSizeMb != null)
        SessionSetArgument.cacheSizeMb.argName: cacheSizeMb,
      if (defaultTrackers != null)
        SessionSetArgument.defaultTrackers.argName: defaultTrackers,
      if (dhtEnabled != null) SessionSetArgument.dhtEnabled.argName: dhtEnabled,
      if (downloadDir != null)
        SessionSetArgument.downloadDir.argName: downloadDir,
      if (downloadDirFreeSpace != null)
        SessionSetArgument.downloadDirFreeSpace.argName: downloadDirFreeSpace,
      if (downloadQueueEnabled != null)
        SessionSetArgument.downloadQueueEnabled.argName: downloadQueueEnabled,
      if (downloadQueueSize != null)
        SessionSetArgument.downloadQueueSize.argName: downloadQueueSize,
      if (encryption != null) SessionSetArgument.encryption.argName: encryption,
      if (idleSeedingLimitEnabled != null)
        SessionSetArgument.idleSeedingLimitEnabled.argName:
            idleSeedingLimitEnabled,
      if (idleSeedingLimit != null)
        SessionSetArgument.idleSeedingLimit.argName: idleSeedingLimit,
      if (incompleteDirEnabled != null)
        SessionSetArgument.incompleteDirEnabled.argName: incompleteDirEnabled,
      if (incompleteDir != null)
        SessionSetArgument.incompleteDir.argName: incompleteDir,
      if (lpdEnabled != null) SessionSetArgument.lpdEnabled.argName: lpdEnabled,
      if (peerLimitGlobal != null)
        SessionSetArgument.peerLimitGlobal.argName: peerLimitGlobal,
      if (peerLimitPerTorrent != null)
        SessionSetArgument.peerLimitPerTorrent.argName: peerLimitPerTorrent,
      if (peerPortRandomOnStart != null)
        SessionSetArgument.peerPortRandomOnStart.argName: peerPortRandomOnStart,
      if (peerPort != null) SessionSetArgument.peerPort.argName: peerPort,
      if (pexEnabled != null) SessionSetArgument.pexEnabled.argName: pexEnabled,
      if (portForwardingEnabled != null)
        SessionSetArgument.portForwardingEnabled.argName: portForwardingEnabled,
      if (queueStalledEnabled != null)
        SessionSetArgument.queueStalledEnabled.argName: queueStalledEnabled,
      if (queueStalledMinutes != null)
        SessionSetArgument.queueStalledMinutes.argName: queueStalledMinutes,
      if (renamePartialFiles != null)
        SessionSetArgument.renamePartialFiles.argName: renamePartialFiles,
      if (scriptTorrentAddedEnabled != null)
        SessionSetArgument.scriptTorrentAddedEnabled.argName:
            scriptTorrentAddedEnabled,
      if (scriptTorrentAddedFilename != null)
        SessionSetArgument.scriptTorrentAddedFilename.argName:
            scriptTorrentAddedFilename,
      if (scriptTorrentDoneEnabled != null)
        SessionSetArgument.scriptTorrentDoneEnabled.argName:
            scriptTorrentDoneEnabled,
      if (scriptTorrentDoneFilename != null)
        SessionSetArgument.scriptTorrentDoneFilename.argName:
            scriptTorrentDoneFilename,
      if (scriptTorrentDoneSeedingEnabled != null)
        SessionSetArgument.scriptTorrentDoneSeedingEnabled.argName:
            scriptTorrentDoneSeedingEnabled,
      if (scriptTorrentDoneSeedingFilename != null)
        SessionSetArgument.scriptTorrentDoneSeedingFilename.argName:
            scriptTorrentDoneSeedingFilename,
      if (seedQueueEnabled != null)
        SessionSetArgument.seedQueueEnabled.argName: seedQueueEnabled,
      if (seedQueueSize != null)
        SessionSetArgument.seedQueueSize.argName: seedQueueSize,
      if (seedRatioLimit != null)
        SessionSetArgument.seedRatioLimit.argName: seedRatioLimit,
      if (seedRatioLimited != null)
        SessionSetArgument.seedRatioLimited.argName: seedRatioLimited,
      if (speedLimitDownEnabled != null)
        SessionSetArgument.speedLimitDownEnabled.argName: speedLimitDownEnabled,
      if (speedLimitDown != null)
        SessionSetArgument.speedLimitDown.argName: speedLimitDown,
      if (speedLimitUpEnabled != null)
        SessionSetArgument.speedLimitUpEnabled.argName: speedLimitUpEnabled,
      if (speedLimitUp != null)
        SessionSetArgument.speedLimitUp.argName: speedLimitUp,
      if (startAddedTorrents != null)
        SessionSetArgument.startAddedTorrents.argName: startAddedTorrents,
      if (trashOriginalTorrentFiles != null)
        SessionSetArgument.trashOriginalTorrentFiles.argName:
            trashOriginalTorrentFiles,
      if (utpEnabled != null) SessionSetArgument.utpEnabled.argName: utpEnabled,
    };
  }
}

class SessionSetResponseParam implements ResponseParam {
  const SessionSetResponseParam();

  factory SessionSetResponseParam.fromJson(JsonMap rawData) =>
      const SessionSetResponseParam();
}
