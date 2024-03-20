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

enum SessionSetArgument {
  altSpeedDown(argName: "alt-speed-down"),
  altSpeedEnabled(argName: "alt-speed-enabled"),
  altSpeedTimeBegin(argName: "alt-speed-time-begin"),
  altSpeedTimeDay(argName: "alt-speed-time-day"),
  altSpeedTimeEnabled(argName: "alt-speed-time-enabled"),
  altSpeedTimeEnd(argName: "alt-speed-time-end"),
  altSpeedUp(argName: "alt-speed-up"),
  blocklistEnabled(argName: "blocklist-enabled"),
  blocklistUrl(argName: "blocklist-url"),
  cacheSizeMb(argName: "cache-size-mb"),
  defaultTrackers(argName: "default-trackers"),
  dhtEnabled(argName: "dht-enabled"),
  downloadDir(argName: "download-dir"),
  @Deprecated("Deprecated rpc-version>=17, use \"free-space\" method instead")
  downloadDirFreeSpace(argName: "download-dir-free-space"),
  downloadQueueEnabled(argName: "download-queue-enabled"),
  downloadQueueSize(argName: "download-queue-size"),
  encryption(argName: "encryption"),
  idleSeedingLimitEnabled(argName: "idle-seeding-limit-enabled"),
  idleSeedingLimit(argName: "idle-seeding-limit"),
  incompleteDirEnabled(argName: "incomplete-dir-enabled"),
  incompleteDir(argName: "incomplete-dir"),
  lpdEnabled(argName: "lpd-enabled"),
  peerLimitGlobal(argName: "peer-limit-global"),
  peerLimitPerTorrent(argName: "peer-limit-per-torrent"),
  peerPortRandomOnStart(argName: "peer-port-random-on-start"),
  peerPort(argName: "peer-port"),
  pexEnabled(argName: "pex-enabled"),
  portForwardingEnabled(argName: "port-forwarding-enabled"),
  queueStalledEnabled(argName: "queue-stalled-enabled"),
  queueStalledMinutes(argName: "queue-stalled-minutes"),
  renamePartialFiles(argName: "rename-partial-files"),
  scriptTorrentAddedEnabled(argName: "script-torrent-added-enabled"),
  scriptTorrentAddedFilename(argName: "script-torrent-added-filename"),
  scriptTorrentDoneEnabled(argName: "script-torrent-done-enabled"),
  scriptTorrentDoneFilename(argName: "script-torrent-done-filename"),
  scriptTorrentDoneSeedingEnabled(
      argName: "script-torrent-done-seeding-enabled"),
  scriptTorrentDoneSeedingFilename(
      argName: "script-torrent-done-seeding-filename"),
  seedQueueEnabled(argName: "seed-queue-enabled"),
  seedQueueSize(argName: "seed-queue-size"),
  seedRatioLimit(argName: "seedRatioLimit"),
  seedRatioLimited(argName: "seedRatioLimited"),
  speedLimitDownEnabled(argName: "speed-limit-down-enabled"),
  speedLimitDown(argName: "speed-limit-down"),
  speedLimitUpEnabled(argName: "speed-limit-up-enabled"),
  speedLimitUp(argName: "speed-limit-up"),
  startAddedTorrents(argName: "start-added-torrents"),
  trashOriginalTorrentFiles(argName: "trash-original-torrent-files"),
  utpEnabled(argName: "utp-enabled");

  final String argName;

  const SessionSetArgument({required this.argName});
}

mixin SessionSetRequestArgsDefine {
  /// Max global download speed (KBps)
  num? get altSpeedDown;

  /// Indicates whether alternative speeds are enabled
  bool? get altSpeedEnabled;

  /// Time to begin alternative speeds (units: minutes after midnight)
  num? get altSpeedTimeBegin;

  /// Day(s) to turn on alternative speeds (look at tr_sched_day)
  num? get altSpeedTimeDay;

  /// Indicates whether alternative speeds time is enabled
  bool? get altSpeedTimeEnabled;

  /// Time to end alternative speeds (units: same)
  num? get altSpeedTimeEnd;

  /// Max global upload speed (KBps)
  num? get altSpeedUp;

  /// Indicates whether the blocklist is enabled
  bool? get blocklistEnabled;

  /// Location of the blocklist to use for `blocklist-update`
  String? get blocklistUrl;

  /// Maximum size of the disk cache (MB)
  num? get cacheSizeMb;

  /// Announce URLs, one per line, and a blank line between tiers
  String? get defaultTrackers;

  /// Indicates whether DHT is enabled in public torrents
  bool? get dhtEnabled;

  /// Default path to download torrents
  String? get downloadDir;

  /// DEPRECATED: Use [freeSpace] method instead.
  @Deprecated("Deprecated rpc-version>=17, use \"free-space\" method instead")
  num? get downloadDirFreeSpace;

  /// Indicates if limiting how many torrents can be downloaded at once is enabled
  bool? get downloadQueueEnabled;

  /// Max number of torrents to download at once (see downloadQueueEnabled)
  num? get downloadQueueSize;

  /// Specifies the encryption method (`required`, `preferred`, `tolerated`)
  String? get encryption;

  /// Indicates if the seeding inactivity limit is honored by default
  bool? get idleSeedingLimitEnabled;

  /// Torrents we're seeding will be stopped if they're idle for this long
  num? get idleSeedingLimit;

  /// Indicates whether incomplete directory is enabled
  bool? get incompleteDirEnabled;

  /// Path for incomplete torrents, when enabled
  String? get incompleteDir;

  /// Indicates whether Local Peer Discovery in public torrents is enabled
  bool? get lpdEnabled;

  /// Maximum global number of peers
  num? get peerLimitGlobal;

  /// Maximum global number of peers per torrent
  num? get peerLimitPerTorrent;

  /// Indicates whether to pick a random peer port on launch
  bool? get peerPortRandomOnStart;

  /// Port number
  num? get peerPort;

  /// Indicates whether Peer Exchange (PEX) in public torrents is enabled
  bool? get pexEnabled;

  /// Indicates whether UPnP or NAT-PMP is enabled to forward peer ports
  bool? get portForwardingEnabled;

  /// Indicates whether idle torrents are considered as stalled
  bool? get queueStalledEnabled;

  /// Torrents that are idle for N minutes aren't counted toward seed-queue-size or download-queue-size
  num? get queueStalledMinutes;

  /// Indicates whether to append `.part` to incomplete files
  bool? get renamePartialFiles;

  /// Indicates whether to call the `added` script
  bool? get scriptTorrentAddedEnabled;

  /// Filename of the script to run when a torrent is added
  String? get scriptTorrentAddedFilename;

  /// Indicates whether to call the `done` script
  bool? get scriptTorrentDoneEnabled;

  /// Filename of the script to run when a torrent is done
  String? get scriptTorrentDoneFilename;

  /// Indicates whether to call the `seeding-done` script
  bool? get scriptTorrentDoneSeedingEnabled;

  /// Filename of the script to run when seeding is done
  String? get scriptTorrentDoneSeedingFilename;

  /// Indicates if limiting how many torrents can be uploaded at once is enabled
  bool? get seedQueueEnabled;

  /// Max number of torrents to upload at once (see seedQueueEnabled)
  num? get seedQueueSize;

  /// The default seed ratio for torrents to use
  num? get seedRatioLimit;

  /// Indicates if seedRatioLimit is honored by default
  bool? get seedRatioLimited;

  /// Indicates whether download speed limit is enabled
  bool? get speedLimitDownEnabled;

  /// Max global download speed (KBps)
  num? get speedLimitDown;

  /// Indicates whether upload speed limit is enabled
  bool? get speedLimitUpEnabled;

  /// Max global upload speed (KBps)
  num? get speedLimitUp;

  /// Indicates whether added torrents will be started right away
  bool? get startAddedTorrents;

  /// Indicates whether the .torrent file of added torrents will be deleted
  bool? get trashOriginalTorrentFiles;

  /// Indicates whether UDP Transport Protocol (UTP) is enabled
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

  SessionSetRequestArgs copyWith({
    num? altSpeedDown,
    bool? altSpeedEnabled,
    num? altSpeedTimeBegin,
    num? altSpeedTimeDay,
    bool? altSpeedTimeEnabled,
    num? altSpeedTimeEnd,
    num? altSpeedUp,
    bool? blocklistEnabled,
    String? blocklistUrl,
    num? cacheSizeMb,
    String? defaultTrackers,
    bool? dhtEnabled,
    String? downloadDir,
    num? downloadDirFreeSpace,
    bool? downloadQueueEnabled,
    num? downloadQueueSize,
    String? encryption,
    bool? idleSeedingLimitEnabled,
    num? idleSeedingLimit,
    bool? incompleteDirEnabled,
    String? incompleteDir,
    bool? lpdEnabled,
    num? peerLimitGlobal,
    num? peerLimitPerTorrent,
    bool? peerPortRandomOnStart,
    num? peerPort,
    bool? pexEnabled,
    bool? portForwardingEnabled,
    bool? queueStalledEnabled,
    num? queueStalledMinutes,
    bool? renamePartialFiles,
    bool? scriptTorrentAddedEnabled,
    String? scriptTorrentAddedFilename,
    bool? scriptTorrentDoneEnabled,
    String? scriptTorrentDoneFilename,
    bool? scriptTorrentDoneSeedingEnabled,
    String? scriptTorrentDoneSeedingFilename,
    bool? seedQueueEnabled,
    num? seedQueueSize,
    num? seedRatioLimit,
    bool? seedRatioLimited,
    bool? speedLimitDownEnabled,
    num? speedLimitDown,
    bool? speedLimitUpEnabled,
    num? speedLimitUp,
    bool? startAddedTorrents,
    bool? trashOriginalTorrentFiles,
    bool? utpEnabled,
  }) {
    return SessionSetRequestArgs(
      altSpeedDown: altSpeedDown ?? this.altSpeedDown,
      altSpeedEnabled: altSpeedEnabled ?? this.altSpeedEnabled,
      altSpeedTimeBegin: altSpeedTimeBegin ?? this.altSpeedTimeBegin,
      altSpeedTimeDay: altSpeedTimeDay ?? this.altSpeedTimeDay,
      altSpeedTimeEnabled: altSpeedTimeEnabled ?? this.altSpeedTimeEnabled,
      altSpeedTimeEnd: altSpeedTimeEnd ?? this.altSpeedTimeEnd,
      altSpeedUp: altSpeedUp ?? this.altSpeedUp,
      blocklistEnabled: blocklistEnabled ?? this.blocklistEnabled,
      blocklistUrl: blocklistUrl ?? this.blocklistUrl,
      cacheSizeMb: cacheSizeMb ?? this.cacheSizeMb,
      defaultTrackers: defaultTrackers ?? this.defaultTrackers,
      dhtEnabled: dhtEnabled ?? this.dhtEnabled,
      downloadDir: downloadDir ?? this.downloadDir,
      downloadDirFreeSpace: downloadDirFreeSpace ?? this.downloadDirFreeSpace,
      downloadQueueEnabled: downloadQueueEnabled ?? this.downloadQueueEnabled,
      downloadQueueSize: downloadQueueSize ?? this.downloadQueueSize,
      encryption: encryption ?? this.encryption,
      idleSeedingLimitEnabled:
          idleSeedingLimitEnabled ?? this.idleSeedingLimitEnabled,
      idleSeedingLimit: idleSeedingLimit ?? this.idleSeedingLimit,
      incompleteDirEnabled: incompleteDirEnabled ?? this.incompleteDirEnabled,
      incompleteDir: incompleteDir ?? this.incompleteDir,
      lpdEnabled: lpdEnabled ?? this.lpdEnabled,
      peerLimitGlobal: peerLimitGlobal ?? this.peerLimitGlobal,
      peerLimitPerTorrent: peerLimitPerTorrent ?? this.peerLimitPerTorrent,
      peerPortRandomOnStart:
          peerPortRandomOnStart ?? this.peerPortRandomOnStart,
      peerPort: peerPort ?? this.peerPort,
      pexEnabled: pexEnabled ?? this.pexEnabled,
      portForwardingEnabled:
          portForwardingEnabled ?? this.portForwardingEnabled,
      queueStalledEnabled: queueStalledEnabled ?? this.queueStalledEnabled,
      queueStalledMinutes: queueStalledMinutes ?? this.queueStalledMinutes,
      renamePartialFiles: renamePartialFiles ?? this.renamePartialFiles,
      scriptTorrentAddedEnabled:
          scriptTorrentAddedEnabled ?? this.scriptTorrentAddedEnabled,
      scriptTorrentAddedFilename:
          scriptTorrentAddedFilename ?? this.scriptTorrentAddedFilename,
      scriptTorrentDoneEnabled:
          scriptTorrentDoneEnabled ?? this.scriptTorrentDoneEnabled,
      scriptTorrentDoneFilename:
          scriptTorrentDoneFilename ?? this.scriptTorrentDoneFilename,
      scriptTorrentDoneSeedingEnabled: scriptTorrentDoneSeedingEnabled ??
          this.scriptTorrentDoneSeedingEnabled,
      scriptTorrentDoneSeedingFilename: scriptTorrentDoneSeedingFilename ??
          this.scriptTorrentDoneSeedingFilename,
      seedQueueEnabled: seedQueueEnabled ?? this.seedQueueEnabled,
      seedQueueSize: seedQueueSize ?? this.seedQueueSize,
      seedRatioLimit: seedRatioLimit ?? this.seedRatioLimit,
      seedRatioLimited: seedRatioLimited ?? this.seedRatioLimited,
      speedLimitDownEnabled:
          speedLimitDownEnabled ?? this.speedLimitDownEnabled,
      speedLimitDown: speedLimitDown ?? this.speedLimitDown,
      speedLimitUpEnabled: speedLimitUpEnabled ?? this.speedLimitUpEnabled,
      speedLimitUp: speedLimitUp ?? this.speedLimitUp,
      startAddedTorrents: startAddedTorrents ?? this.startAddedTorrents,
      trashOriginalTorrentFiles:
          trashOriginalTorrentFiles ?? this.trashOriginalTorrentFiles,
      utpEnabled: utpEnabled ?? this.utpEnabled,
    );
  }
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
