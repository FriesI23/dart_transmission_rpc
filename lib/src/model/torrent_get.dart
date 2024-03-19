// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import '../exception.dart';
import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';
import 'torrent.dart';

enum TorrentGetArgument {
  /// The last time uploaded or downloaded piece data on this torrent
  activityDate(argName: "activityDate"),

  /// When the torrent was first added.
  addedDate(argName: "addedDate"),

  /// An array of `pieceCount` numbers representing the number of connected
  /// peers that have each piece, or -1 if server already have the piece.
  availability(argName: "availability"),

  /// torrent's bandwidth priority, should be -1, 0, or 1, check
  /// [BandwidthPriority] get more information.
  bandwidthPriority(argName: "bandwidthPriority"),

  /// torrent comment text
  comment(argName: "comment"),

  /// Byte count of all the corrupt data you've ever downloaded for
  /// this torrent. If you're on a poisoned torrent, this number can
  /// grow very large.
  corruptEver(argName: "corruptEver"),

  /// torrent creator
  creator(argName: "creator"),

  /// when torrent task created.
  dateCreated(argName: "dateCreated"),

  /// Byte count of all the piece data server want and don't have yet,
  /// but that a connected peer does have. [0...leftUntilDone]
  desiredAvailable(argName: "desiredAvailable"),

  /// When the torrent finished downloading.
  doneDate(argName: "doneDate"),

  /// torrent download directory
  downloadDir(argName: "downloadDir"),

  /// Byte count of all the non-corrupt data you've ever downloaded for this
  /// torrent. If you deleted the files and downloaded a second time,
  /// this will be `2*totalSize`..
  downloadedEver(argName: "downloadedEver"),

  /// maximum download speed (KBps)
  downloadLimit(argName: "downloadLimit"),

  /// true if [downloadLimit] is honored
  downloadLimited(argName: "downloadLimited"),

  /// The last time during this session that a rarely-changing field changed
  /// -- e.g. any metainfo field (trackers, filenames, name) or download
  /// directory.
  /// It can monitor this to know when to reload fields that rarely change.
  editDate(argName: "editDate"),

  /// Defines what kind of text is in errorString, check [ServerErrorCode]
  /// get more information.
  error(argName: "error"),

  /// A warning or error message regarding the torrent, see [error]
  errorString(argName: "errorString"),

  /// If downloading, estimated number of seconds left until the torrent is
  /// done. If seeding, estimated number of seconds left until seed ratio
  /// is reached
  eta(argName: "eta"),

  /// If seeding, number of seconds left until the idle time limit is reached.
  etaIdle(argName: "etaIdle"),

  /// Number of torrent files
  fileCount(argName: "file-count"),

  /// Files information with torrent
  files(argName: "files"),

  /// A file's non-constant properties.
  fileStats(argName: "fileStats"),

  /// bandwith group name, see api [groupSet] and [groupGet]
  group(argName: "group"),

  /// torrent's hashed string
  hashString(argName: "hashString"),

  /// Byte count of all the partial piece data server have for this torrent.
  /// As pieces become complete, this value may decrease as portions of it
  /// are moved to [corruptEver] or [haveValid].
  haveUnchecked(argName: "haveUnchecked"),

  /// Byte count of all the checksum-verified data server have for this torrent.
  haveValid(argName: "haveValid"),

  /// true if session upload limits are honored
  honorsSessionLimits(argName: "honorsSessionLimits"),

  /// torrent id
  id(argName: "id"),

  ///  A torrent is considered finished if it has met its seed ratio.
  /// As a result, only paused torrents can be finished
  isFinished(argName: "isFinished"),

  /// True if this torrent is private
  isPrivate(argName: "isPrivate"),

  /// True if the torrent is running, but has been idle for long enough
  /// to be considered stalled.
  isStalled(argName: "isStalled"),

  /// Torrent labels
  labels(argName: "labels"),

  /// Byte count of how much data is left to be downloaded until server got
  /// all the pieces that it want
  leftUntilDone(argName: "leftUntilDone"),

  /// Torrent Magnet link, e.g.: magnet:?...
  magnetLink(argName: "magnetLink"),

  manualAnnounceTime(argName: "manualAnnounceTime"),

  maxConnectedPeers(argName: "maxConnectedPeers"),

  /// How much of the metadata the torrent has. For torrents added from a
  /// torrent this will always be 1. For magnet links, this number will from
  /// from 0 to 1 as the metadata is downloaded. Range is [0..1]
  metadataPercentComplete(argName: "metadataPercentComplete"),

  /// torrent name
  name(argName: "name"),

  /// Maximum number of peers
  peerLimit(argName: "peer-limit"),

  /// Peer's information
  peers(argName: "peers"),

  /// Number of peers that server connected to
  peersConnected(argName: "peersConnected"),

  /// How many connected peers server found out about from the tracker,
  /// or from pex, or from incoming connections, or from our resume file.
  peersFrom(argName: "peersFrom"),

  ///  Number of peers that server sending data to
  peersGettingFromUs(argName: "peersGettingFromUs"),

  /// Number of peers that are sending data to us.
  peersSendingToUs(argName: "peersSendingToUs"),

  /// How much has been downloaded of the entire torrent. Range is [0..1]
  percentComplete(argName: "percentComplete"),

  /// How much has been downloaded of the files the user wants. This differs
  /// from percentComplete if the user wants only some of the torrent's files.
  /// Range is [0..1], see [leftUntilDone]
  percentDone(argName: "percentDone"),

  /// A bitfield holding [pieceCount] flags which are set to `true`/`1`
  /// if server have the piece matching that position.
  pieces(argName: "pieces"),

  pieceCount(argName: "pieceCount"),

  /// Checkout how many KiB each piece should be
  pieceSize(argName: "pieceSize"),

  /// An array of torrent file count numbers.
  /// Each is the [BandwidthPriority.nice] for the corresponding file.
  priorities(argName: "priorities"),

  primaryMimeType(argName: "primary-mime-type"),

  /// position of this torrent in its queue [0...n)
  queuePosition(argName: "queuePosition"),

  /// Download rate (B/s)
  rateDownload(argName: "rateDownload"),

  /// Upload rate (B/s)
  rateUpload(argName: "rateUpload"),

  /// Percentage of how much of the files has been verified. When it gets to 1,
  /// the verify process is done. Range is [0..1]
  recheckProgress(argName: "recheckProgress"),

  /// Cumulative seconds the torrent's ever spent downloading
  secondsDownloading(argName: "secondsDownloading"),

  /// Cumulative seconds the torrent's ever spent seeding
  secondsSeeding(argName: "secondsSeeding"),

  /// torrent-level number of minutes of seeding inactivity
  seedIdleLimit(argName: "seedIdleLimit"),

  /// Figger out which seeding inactivity to use. see [IdleLimitMode.code]
  seedIdleMode(argName: "seedIdleMode"),

  /// the default seed ratio for torrents to use
  seedRatioLimit(argName: "seedRatioLimit"),

  /// which ratio to use. see [RatioLimitMode.code]
  seedRatioMode(argName: "seedRatioMode"),

  /// download torrent pieces sequentially
  sequentialDownload(argName: "sequentialDownload"),

  /// Byte count of all the piece data we'll have downloaded when we're done,
  /// whether or not we have it yet. If we only want some of the files,
  /// this may be less than [totalSize]. Range is [0...totalSize]
  sizeWhenDone(argName: "sizeWhenDone"),

  /// When the torrent was last started.
  startDate(argName: "startDate"),

  /// torrent status, see [TorrentStatus]
  status(argName: "status"),

  /// torrent tracker information
  trackers(argName: "trackers"),

  // TODO: add custom type TrackerList
  /// string of announce URLs, one per line, and a blank line between tiers.
  trackerList(argName: "trackerList"),

  /// Tracker's State information
  trackerStats(argName: "trackerStats"),

  /// torrent total size (Bytes)
  totalSize(argName: "totalSize"),

  torrentFile(argName: "torrentFile"),

  /// Byte count of all data you've ever uploaded for this torrent.
  uploadedEver(argName: "uploadedEver"),

  /// maximum upload speed (KBps)
  uploadLimit(argName: "uploadLimit"),

  /// `true` if [uploadLimit] is honored
  uploadLimited(argName: "uploadLimited"),

  uploadRatio(argName: "uploadRatio"),

  /// An array of torrent file count 0/1, 1 (true) if the corresponding file
  /// is to be downloaded
  wanted(argName: "wanted"),

  webseeds(argName: "webseeds"),

  /// Number of webseeds that are sending data to us.
  webseedsSendingToUs(argName: "webseedsSendingToUs");

  final String argName;

  const TorrentGetArgument({required this.argName});
}

abstract class TorrentGetRequestParam implements RequestParam {
  final List<TorrentGetArgument>? fields;
  final TorrentIds? ids;

  const TorrentGetRequestParam(this.fields, this.ids);

  static final _verionBuilderMap = <ParamBuilderEntry2<TorrentGetRequestParam,
      List<TorrentGetArgument>?, TorrentIds?>>[
    MapEntry(18, (fields, ids) => _TorrentGetRequestParamRpc18(fields, ids)),
    MapEntry(17, (fields, ids) => _TorrentGetRequestParamRpc17(fields, ids)),
    MapEntry(16, (fields, ids) => _TorrentGetRequestParamRpc16(fields, ids)),
    MapEntry(15, (fields, ids) => _TorrentGetRequestParamRpc15(fields, ids)),
  ];

  factory TorrentGetRequestParam.build({
    ServerRpcVersion? version,
    required List<TorrentGetArgument>? fields,
    TorrentIds? ids,
  }) =>
      buildRequestParam2(version, fields, ids,
          nullVersionBuilder: (fields, ids) =>
              _TorrentGetRequestParam(fields, ids),
          defaultVersionBuilder: (fields, ids) =>
              _TorrentGetRequestParam(fields, ids),
          versionBuilers: _verionBuilderMap);

  Set<TorrentGetArgument> get allowedFields;
  Set<TorrentGetArgument> get deprecatedFields;

  @override
  String? check() {
    if (fields == null) return null;
    if (fields!.isEmpty) {
      throw const TransmissionCheckError("fields should not be empty");
    }
    final allowedChecker = RequestParamArgsChecker<TorrentGetArgument>(
        label: "$runtimeType.prohibited",
        fields: fields!,
        failedChecker: (f) => !allowedFields.contains(f));
    final deprecatedChecker = RequestParamArgsChecker<TorrentGetArgument>(
        label: "$runtimeType.deprecated",
        fields: fields!,
        failedChecker: (f) => deprecatedFields.contains(f));
    return RequestParam.buildCheckResult([
      allowedChecker.check(),
      deprecatedChecker.check(),
    ]);
  }

  @override
  JsonMap toRpcJson() => {
        "fields": (fields != null
                ? fields!.where((e) => allowedFields.contains(e))
                : allowedFields)
            .map((e) => e.argName)
            .toList(),
        if (ids != null && ids!.isNotEmpty) "ids": ids!.toRpcJson(),
      };
}

class _TorrentGetRequestParam extends TorrentGetRequestParam {
  static final _allowedFields = {
    TorrentGetArgument.addedDate,
    TorrentGetArgument.activityDate,
    TorrentGetArgument.bandwidthPriority,
    TorrentGetArgument.comment,
    TorrentGetArgument.corruptEver,
    TorrentGetArgument.creator,
    TorrentGetArgument.dateCreated,
    TorrentGetArgument.desiredAvailable,
    TorrentGetArgument.doneDate,
    TorrentGetArgument.downloadDir,
    TorrentGetArgument.downloadedEver,
    TorrentGetArgument.downloadLimit,
    TorrentGetArgument.downloadLimited,
    TorrentGetArgument.error,
    TorrentGetArgument.errorString,
    TorrentGetArgument.eta,
    TorrentGetArgument.files,
    TorrentGetArgument.fileStats,
    TorrentGetArgument.hashString,
    TorrentGetArgument.haveUnchecked,
    TorrentGetArgument.haveValid,
    TorrentGetArgument.honorsSessionLimits,
    TorrentGetArgument.id,
    TorrentGetArgument.isFinished,
    TorrentGetArgument.isPrivate,
    TorrentGetArgument.isStalled,
    TorrentGetArgument.leftUntilDone,
    TorrentGetArgument.magnetLink,
    TorrentGetArgument.manualAnnounceTime,
    TorrentGetArgument.maxConnectedPeers,
    TorrentGetArgument.metadataPercentComplete,
    TorrentGetArgument.name,
    TorrentGetArgument.peerLimit,
    TorrentGetArgument.peers,
    TorrentGetArgument.peersConnected,
    TorrentGetArgument.peersFrom,
    TorrentGetArgument.peersGettingFromUs,
    TorrentGetArgument.peersSendingToUs,
    TorrentGetArgument.percentDone,
    TorrentGetArgument.pieces,
    TorrentGetArgument.pieceCount,
    TorrentGetArgument.pieceSize,
    TorrentGetArgument.priorities,
    TorrentGetArgument.queuePosition,
    TorrentGetArgument.rateDownload,
    TorrentGetArgument.rateUpload,
    TorrentGetArgument.recheckProgress,
    TorrentGetArgument.secondsDownloading,
    TorrentGetArgument.secondsSeeding,
    TorrentGetArgument.seedIdleLimit,
    TorrentGetArgument.seedIdleMode,
    TorrentGetArgument.seedRatioLimit,
    TorrentGetArgument.seedRatioMode,
    TorrentGetArgument.sizeWhenDone,
    TorrentGetArgument.startDate,
    TorrentGetArgument.status,
    TorrentGetArgument.trackers,
    TorrentGetArgument.trackerStats,
    TorrentGetArgument.totalSize,
    TorrentGetArgument.torrentFile,
    TorrentGetArgument.uploadedEver,
    TorrentGetArgument.uploadLimit,
    TorrentGetArgument.uploadLimited,
    TorrentGetArgument.uploadRatio,
    TorrentGetArgument.wanted,
    TorrentGetArgument.webseeds,
    TorrentGetArgument.webseedsSendingToUs,
  };

  const _TorrentGetRequestParam(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentGetArgument> get deprecatedFields => {};
}

class _TorrentGetRequestParamRpc15 extends _TorrentGetRequestParam {
  static final _allowedFields = _TorrentGetRequestParam._allowedFields.union({
    TorrentGetArgument.etaIdle,
  });

  const _TorrentGetRequestParamRpc15(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;
}

class _TorrentGetRequestParamRpc16 extends _TorrentGetRequestParamRpc15 {
  static final _allowedFields =
      _TorrentGetRequestParamRpc15._allowedFields.union({
    TorrentGetArgument.labels,
    TorrentGetArgument.editDate,
  });

  const _TorrentGetRequestParamRpc16(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  JsonMap toRpcJson() {
    // TODO: use "table" format request and handle result
    JsonMap data = super.toRpcJson();
    data["format"] = "objects";
    return data;
  }
}

class _TorrentGetRequestParamRpc17 extends _TorrentGetRequestParamRpc16 {
  static final _allowedFields =
      _TorrentGetRequestParamRpc16._allowedFields.union({
    TorrentGetArgument.availability,
    TorrentGetArgument.fileCount,
    TorrentGetArgument.group,
    TorrentGetArgument.percentComplete,
    TorrentGetArgument.primaryMimeType,
    TorrentGetArgument.trackerList,
  });

  const _TorrentGetRequestParamRpc17(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;
}

class _TorrentGetRequestParamRpc18 extends _TorrentGetRequestParamRpc17 {
  static final _allowedFields =
      _TorrentGetRequestParamRpc17._allowedFields.union({
    TorrentGetArgument.sequentialDownload,
  });

  const _TorrentGetRequestParamRpc18(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;
}

class Availability {
  final List<int> piecesCount;

  const Availability(this.piecesCount);

  factory Availability.fromJson(List rawData) {
    return Availability(rawData.map((e) {
      if (e is num) return e.toInt();
      if (e is int) return e;
      if (e is double) return e.toInt();
      return int.parse(e.toString());
    }).toList());
  }

  bool isAlreadyHavePiece(int index) =>
      piecesCount.elementAtOrNull(index)?.isNegative ?? false;

  int? getPieceConnectedPeerCount(int index) =>
      isAlreadyHavePiece(index) ? piecesCount.elementAtOrNull(index) : null;
}

class File {
  final num bytesCompleted;
  final num length;
  final String name;
  final num? beginPiece;
  final num? endPiece;

  const File({
    required this.bytesCompleted,
    required this.length,
    required this.name,
    this.beginPiece,
    this.endPiece,
  });

  factory File.fromJson(JsonMap rawData) => File(
        bytesCompleted: rawData["bytesCompleted"] as num,
        length: rawData["length"] as num,
        name: rawData["name"] as String,
        beginPiece: rawData["beginPiece"] as num?,
        endPiece: rawData["endPiece"] as num?,
      );

  @override
  String toString() =>
      'File {name: $name, bytesCompleted: $bytesCompleted, length: $length, '
      'beginPiece: $beginPiece, endPiece: $endPiece}';
}

class FileStat {
  final num bytesCompleted;
  final bool wanted;
  final num priority;

  const FileStat({
    required this.bytesCompleted,
    required this.wanted,
    required this.priority,
  });

  factory FileStat.fromJson(JsonMap rawData) => FileStat(
        bytesCompleted: rawData["bytesCompleted"] as num,
        wanted: rawData["wanted"] as bool,
        priority: rawData["priority"] as num,
      );

  @override
  String toString() =>
      'FileStat {bytesCompleted: $bytesCompleted, wanted: $wanted, '
      'priority: $priority}';
}

class Peer {
  final String address;
  final String clientName;
  final bool clientIsChoked;
  final bool clientIsInterested;
  final String flagStr;
  final bool isDownloadingFrom;
  final bool isEncrypted;
  final bool isIncoming;
  final bool isUploadingTo;
  final bool isUTP;
  final bool peerIsChoked;
  final bool peerIsInterested;
  final num port;
  final num progress;
  final num rateToClient;
  final num rateToPeer;

  const Peer({
    required this.address,
    required this.clientName,
    required this.clientIsChoked,
    required this.clientIsInterested,
    required this.flagStr,
    required this.isDownloadingFrom,
    required this.isEncrypted,
    required this.isIncoming,
    required this.isUploadingTo,
    required this.isUTP,
    required this.peerIsChoked,
    required this.peerIsInterested,
    required this.port,
    required this.progress,
    required this.rateToClient,
    required this.rateToPeer,
  });

  factory Peer.fromJson(JsonMap rawData) => Peer(
        address: rawData['address'] as String,
        clientName: rawData['clientName'] as String,
        clientIsChoked: rawData['clientIsChoked'] as bool,
        clientIsInterested: rawData['clientIsInterested'] as bool,
        flagStr: rawData['flagStr'] as String,
        isDownloadingFrom: rawData['isDownloadingFrom'] as bool,
        isEncrypted: rawData['isEncrypted'] as bool,
        isIncoming: rawData['isIncoming'] as bool,
        isUploadingTo: rawData['isUploadingTo'] as bool,
        isUTP: rawData['isUTP'] as bool,
        peerIsChoked: rawData['peerIsChoked'] as bool,
        peerIsInterested: rawData['peerIsInterested'] as bool,
        port: rawData['port'] as num,
        progress: rawData['progress'] as num,
        rateToClient: rawData['rateToClient'] as num,
        rateToPeer: rawData['rateToPeer'] as num,
      );
}

class PeersFrom {
  final num fromCache;
  final num fromDht;
  final num fromIncoming;
  final num fromLpd;
  final num fromLtep;
  final num fromPex;
  final num fromTracker;

  const PeersFrom({
    required this.fromCache,
    required this.fromDht,
    required this.fromIncoming,
    required this.fromLpd,
    required this.fromLtep,
    required this.fromPex,
    required this.fromTracker,
  });

  factory PeersFrom.fromJson(JsonMap rawData) {
    return PeersFrom(
      fromCache: rawData['fromCache'] as num,
      fromDht: rawData['fromDht'] as num,
      fromIncoming: rawData['fromIncoming'] as num,
      fromLpd: rawData['fromLpd'] as num,
      fromLtep: rawData['fromLtep'] as num,
      fromPex: rawData['fromPex'] as num,
      fromTracker: rawData['fromTracker'] as num,
    );
  }
}

class Pieces {
  final Uint8List pieces;

  const Pieces(this.pieces);

  factory Pieces.fromString(String rawData) {
    final p = base64Decode(rawData);
    return Pieces(p);
  }

  Uint8? elementAtOrNull(int index) => pieces.elementAtOrNull(index) as Uint8?;
}

class Tracker {
  final String announce;
  final TrackerId id;
  final String scrape;
  final num tier;
  final String? sitename;

  const Tracker({
    required this.announce,
    required this.id,
    required this.scrape,
    required this.tier,
    this.sitename,
  });

  factory Tracker.fromJson(JsonMap rawData) {
    return Tracker(
      announce: rawData['announce'] as String,
      id: rawData['id'] as num,
      scrape: rawData['scrape'] as String,
      tier: rawData['tier'] as num,
      sitename: rawData['sitename'] as String?,
    );
  }
}

class TrackerStat {
  final num announceState;
  final String announce;
  final num downloadCount;
  final bool hasAnnounced;
  final bool hasScraped;
  final String host;
  final TrackerId id;
  final bool isBackup;
  final num lastAnnouncePeerCount;
  final String lastAnnounceResult;
  final num lastAnnounceStartTime;
  final bool lastAnnounceSucceeded;
  final num lastAnnounceTime;
  final bool lastAnnounceTimedOut;
  final String lastScrapeResult;
  final num lastScrapeStartTime;
  final bool lastScrapeSucceeded;
  final num lastScrapeTime;
  final bool lastScrapeTimedOut;
  final num leecherCount;
  final num nextAnnounceTime;
  final num nextScrapeTime;
  final num scrapeState;
  final String scrape;
  final num seederCount;
  final num tier;
  final String? sitename;

  const TrackerStat({
    required this.announceState,
    required this.announce,
    required this.downloadCount,
    required this.hasAnnounced,
    required this.hasScraped,
    required this.host,
    required this.id,
    required this.isBackup,
    required this.lastAnnouncePeerCount,
    required this.lastAnnounceResult,
    required this.lastAnnounceStartTime,
    required this.lastAnnounceSucceeded,
    required this.lastAnnounceTime,
    required this.lastAnnounceTimedOut,
    required this.lastScrapeResult,
    required this.lastScrapeStartTime,
    required this.lastScrapeSucceeded,
    required this.lastScrapeTime,
    required this.lastScrapeTimedOut,
    required this.leecherCount,
    required this.nextAnnounceTime,
    required this.nextScrapeTime,
    required this.scrapeState,
    required this.scrape,
    required this.seederCount,
    required this.tier,
    this.sitename,
  });

  factory TrackerStat.fromJson(JsonMap rawData) {
    bool handleNumOrBoolToBool(dynamic rawVal) {
      if (rawVal is bool) return rawVal;
      if (rawVal is num || rawVal is int) return rawVal != 0;
      return false;
    }

    return TrackerStat(
      announceState: rawData['announceState'] as num,
      announce: rawData['announce'] as String,
      downloadCount: rawData['downloadCount'] as num,
      hasAnnounced: rawData['hasAnnounced'] as bool,
      hasScraped: rawData['hasScraped'] as bool,
      host: rawData['host'] as String,
      id: rawData['id'] as num,
      isBackup: rawData['isBackup'] as bool,
      lastAnnouncePeerCount: rawData['lastAnnouncePeerCount'] as num,
      lastAnnounceResult: rawData['lastAnnounceResult'] as String,
      lastAnnounceStartTime: rawData['lastAnnounceStartTime'] as num,
      lastAnnounceSucceeded: rawData['lastAnnounceSucceeded'] as bool,
      lastAnnounceTime: rawData['lastAnnounceTime'] as num,
      // lastAnnounceTimedOut return int whtn rpc<16 and return bool currently.
      lastAnnounceTimedOut:
          handleNumOrBoolToBool(rawData['lastAnnounceTimedOut']),
      lastScrapeResult: rawData['lastScrapeResult'] as String,
      lastScrapeStartTime: rawData['lastScrapeStartTime'] as num,
      lastScrapeSucceeded: rawData['lastScrapeSucceeded'] as bool,
      lastScrapeTime: rawData['lastScrapeTime'] as num,
      // lastScrapeTimedOut return int before rpc<16 and return bool currently.
      lastScrapeTimedOut: handleNumOrBoolToBool(rawData['lastScrapeTimedOut']),
      leecherCount: rawData['leecherCount'] as num,
      nextAnnounceTime: rawData['nextAnnounceTime'] as num,
      nextScrapeTime: rawData['nextScrapeTime'] as num,
      scrapeState: rawData['scrapeState'] as num,
      scrape: rawData['scrape'] as String,
      seederCount: rawData['seederCount'] as num,
      tier: rawData['tier'] as num,
      sitename: rawData['sitename'] as String?,
    );
  }
}

class TorrentInfo {
  final num? activityDate;
  final num? addedDate;
  final Availability? availability;
  final num? bandwidthPriority;
  final String? comment;
  final num? corruptEver;
  final String? creator;
  final num? dateCreated;
  final num? desiredAvailable;
  final num? doneDate;
  final String? downloadDir;
  final num? downloadedEver;
  final num? downloadLimit;
  final bool? downloadLimited;
  final num? editDate;
  final num? error;
  final String? errorString;
  final num? eta;
  final num? etaIdle;
  final num? fileCount;
  final List<File>? files;
  final List<FileStat>? fileStats;
  final String? group;
  final num? haveUnchecked;
  final num? haveValid;
  final bool? honorsSessionLimits;
  final TorrentId? id;
  final bool? isFinished;
  final bool? isPrivate;
  final bool? isStalled;
  final List<String>? labels;
  final num? leftUntilDone;
  final String? magnetLink;
  final num? manualAnnounceTime;
  final num? maxConnectedPeers;
  final num? metadataPercentComplete;
  final String? name;
  final num? peerLimit;
  final List<Peer>? peers;
  final num? peersConnected;
  final PeersFrom? peersFrom;
  final num? peersGettingFromUs;
  final num? peersSendingToUs;
  final num? percentComplete;
  final num? percentDone;
  final String? pieces;
  final num? pieceCount;
  final num? pieceSize;
  final List<num>? priorities;
  final String? primaryMimeType;
  final num? queuePosition;
  final num? rateDownload;
  final num? rateUpload;
  final num? recheckProgress;
  final num? secondsDownloading;
  final num? secondsSeeding;
  final num? seedIdleLimit;
  final IdleLimitMode? seedIdleMode;
  final num? seedRatioLimit;
  final RatioLimitMode? seedRatioMode;
  final bool? sequentialDownload;
  final num? sizeWhenDone;
  final num? startDate;
  final TorrentStatus? status;
  final List<Tracker>? trackers;
  final String? trackerList;
  final List<TrackerStat>? trackerStats;
  final num? totalSize;
  final String? torrentFile;
  final num? uploadedEver;
  final num? uploadLimit;
  final bool? uploadLimited;
  final num? uploadRatio;
  final List<bool>? wanted;
  final List<String>? webseeds;
  final num? webseedsSendingToUs;

  TorrentInfo({
    this.activityDate,
    this.addedDate,
    this.availability,
    this.bandwidthPriority,
    this.comment,
    this.corruptEver,
    this.creator,
    this.dateCreated,
    this.desiredAvailable,
    this.doneDate,
    this.downloadDir,
    this.downloadedEver,
    this.downloadLimit,
    this.downloadLimited,
    this.editDate,
    this.error,
    this.errorString,
    this.eta,
    this.etaIdle,
    this.fileCount,
    this.files,
    this.fileStats,
    this.group,
    this.haveUnchecked,
    this.haveValid,
    this.honorsSessionLimits,
    this.id,
    this.isFinished,
    this.isPrivate,
    this.isStalled,
    this.labels,
    this.leftUntilDone,
    this.magnetLink,
    this.manualAnnounceTime,
    this.maxConnectedPeers,
    this.metadataPercentComplete,
    this.name,
    this.peerLimit,
    this.peers,
    this.peersConnected,
    this.peersFrom,
    this.peersGettingFromUs,
    this.peersSendingToUs,
    this.percentComplete,
    this.percentDone,
    this.pieces,
    this.pieceCount,
    this.pieceSize,
    this.priorities,
    this.primaryMimeType,
    this.queuePosition,
    this.rateDownload,
    this.rateUpload,
    this.recheckProgress,
    this.secondsDownloading,
    this.secondsSeeding,
    this.seedIdleLimit,
    this.seedIdleMode,
    this.seedRatioLimit,
    this.seedRatioMode,
    this.sequentialDownload,
    this.sizeWhenDone,
    this.startDate,
    this.status,
    this.trackers,
    this.trackerList,
    this.trackerStats,
    this.totalSize,
    this.torrentFile,
    this.uploadedEver,
    this.uploadLimit,
    this.uploadLimited,
    this.uploadRatio,
    this.wanted,
    this.webseeds,
    this.webseedsSendingToUs,
  });

  static List<bool>? buildWanted(List? rawData) {
    return rawData?.map((e) {
      if (e is bool) return e;
      if (e is int || e is num || e is double) return e == 1 ? true : false;
      if (e == null) return false;
      return e.toString().isNotEmpty;
    }).toList();
  }

  static List<num>? buildPriorities(List? rawData) {
    return rawData?.map((e) {
      if (e is int || e is num) return e as num;
      if (e is double) return e.toInt();
      return num.parse(e);
    }).toList();
  }

  factory TorrentInfo.fromJson(JsonMap rawData) {
    TorrentId? buildId() {
      final rawId = rawData[TorrentGetArgument.id.argName] as num?;
      final rawHash = rawData[TorrentGetArgument.hashString.argName] as String?;
      return !(rawId == null && rawHash == null)
          ? TorrentId(id: rawId?.toInt(), hashStr: rawHash)
          : null;
    }

    IdleLimitMode? buildSeedIdleMode() {
      final rawMode = rawData[TorrentGetArgument.seedIdleMode.argName] as num?;
      return rawMode != null ? IdleLimitMode.code(rawMode.toInt()) : null;
    }

    RatioLimitMode? buildSeedRatioMode() {
      final rawMode = rawData[TorrentGetArgument.seedRatioMode.argName] as num?;
      return rawMode != null ? RatioLimitMode.code(rawMode.toInt()) : null;
    }

    return TorrentInfo(
      activityDate: rawData[TorrentGetArgument.activityDate.argName] as num?,
      addedDate: rawData[TorrentGetArgument.addedDate.argName] as num?,
      availability: rawData[TorrentGetArgument.availability.argName] != null
          ? Availability.fromJson(
              rawData[TorrentGetArgument.availability.argName])
          : null,
      bandwidthPriority:
          rawData[TorrentGetArgument.bandwidthPriority.argName] as num?,
      comment: rawData[TorrentGetArgument.comment.argName] as String?,
      corruptEver: rawData[TorrentGetArgument.corruptEver.argName] as num?,
      creator: rawData[TorrentGetArgument.creator.argName] as String?,
      dateCreated: rawData[TorrentGetArgument.dateCreated.argName] as num?,
      desiredAvailable:
          rawData[TorrentGetArgument.desiredAvailable.argName] as num?,
      doneDate: rawData[TorrentGetArgument.doneDate.argName] as num?,
      downloadDir: rawData[TorrentGetArgument.downloadDir.argName] as String?,
      downloadedEver:
          rawData[TorrentGetArgument.downloadedEver.argName] as num?,
      downloadLimit: rawData[TorrentGetArgument.downloadLimit.argName] as num?,
      downloadLimited:
          rawData[TorrentGetArgument.downloadLimited.argName] as bool?,
      editDate: rawData[TorrentGetArgument.editDate.argName] as num?,
      error: rawData[TorrentGetArgument.error.argName] as num?,
      errorString: rawData[TorrentGetArgument.errorString.argName] as String?,
      eta: rawData[TorrentGetArgument.eta.argName] as num?,
      etaIdle: rawData[TorrentGetArgument.etaIdle.argName] as num?,
      fileCount: rawData[TorrentGetArgument.fileCount.argName] as num?,
      files: (rawData[TorrentGetArgument.files.argName] as List?)
          ?.map((file) => File.fromJson(file))
          .toList(),
      fileStats: (rawData[TorrentGetArgument.fileStats.argName] as List?)
          ?.map((fileStat) => FileStat.fromJson(fileStat))
          .toList(),
      group: rawData[TorrentGetArgument.group.argName] as String?,
      haveUnchecked: rawData[TorrentGetArgument.haveUnchecked.argName] as num?,
      haveValid: rawData[TorrentGetArgument.haveValid.argName] as num?,
      honorsSessionLimits:
          rawData[TorrentGetArgument.honorsSessionLimits.argName] as bool?,
      id: buildId(),
      isFinished: rawData[TorrentGetArgument.isFinished.argName] as bool?,
      isPrivate: rawData[TorrentGetArgument.isPrivate.argName] as bool?,
      isStalled: rawData[TorrentGetArgument.isStalled.argName] as bool?,
      labels: (rawData[TorrentGetArgument.labels.argName] as List?)
          ?.map((label) => label.toString())
          .toList(),
      leftUntilDone: rawData[TorrentGetArgument.leftUntilDone.argName] as num?,
      magnetLink: rawData[TorrentGetArgument.magnetLink.argName] as String?,
      manualAnnounceTime:
          rawData[TorrentGetArgument.manualAnnounceTime.argName] as num?,
      maxConnectedPeers:
          rawData[TorrentGetArgument.maxConnectedPeers.argName] as num?,
      metadataPercentComplete:
          rawData[TorrentGetArgument.metadataPercentComplete.argName] as num?,
      name: rawData[TorrentGetArgument.name.argName] as String?,
      peerLimit: rawData[TorrentGetArgument.peerLimit.argName] as num?,
      peers: (rawData[TorrentGetArgument.peers.argName] as List?)
          ?.map((peer) => Peer.fromJson(peer))
          .toList(),
      peersConnected:
          rawData[TorrentGetArgument.peersConnected.argName] as num?,
      peersFrom: rawData[TorrentGetArgument.peersFrom.argName] != null
          ? PeersFrom.fromJson(rawData[TorrentGetArgument.peersFrom.argName])
          : null,
      peersGettingFromUs:
          rawData[TorrentGetArgument.peersGettingFromUs.argName] as num?,
      peersSendingToUs:
          rawData[TorrentGetArgument.peersSendingToUs.argName] as num?,
      percentComplete:
          rawData[TorrentGetArgument.percentComplete.argName] as num?,
      percentDone: rawData[TorrentGetArgument.percentDone.argName] as num?,
      pieces: rawData[TorrentGetArgument.pieces.argName] as String?,
      pieceCount: rawData[TorrentGetArgument.pieceCount.argName] as num?,
      pieceSize: rawData[TorrentGetArgument.pieceSize.argName] as num?,
      priorities: buildPriorities(
          rawData[TorrentGetArgument.priorities.argName] as List?),
      primaryMimeType:
          rawData[TorrentGetArgument.primaryMimeType.argName] as String?,
      queuePosition: rawData[TorrentGetArgument.queuePosition.argName] as num?,
      rateDownload: rawData[TorrentGetArgument.rateDownload.argName] as num?,
      rateUpload: rawData[TorrentGetArgument.rateUpload.argName] as num?,
      recheckProgress:
          rawData[TorrentGetArgument.recheckProgress.argName] as num?,
      secondsDownloading:
          rawData[TorrentGetArgument.secondsDownloading.argName] as num?,
      secondsSeeding:
          rawData[TorrentGetArgument.secondsSeeding.argName] as num?,
      seedIdleLimit: rawData[TorrentGetArgument.seedIdleLimit.argName] as num?,
      seedIdleMode: buildSeedIdleMode(),
      seedRatioLimit:
          rawData[TorrentGetArgument.seedRatioLimit.argName] as num?,
      seedRatioMode: buildSeedRatioMode(),
      sequentialDownload:
          rawData[TorrentGetArgument.sequentialDownload.argName] as bool?,
      sizeWhenDone: rawData[TorrentGetArgument.sizeWhenDone.argName] as num?,
      startDate: rawData[TorrentGetArgument.startDate.argName] as num?,
      status: rawData[TorrentGetArgument.status.argName] != null
          ? TorrentStatus.fromVal(
              (rawData[TorrentGetArgument.status.argName] as num).toInt())
          : null,
      trackers: (rawData[TorrentGetArgument.trackers.argName] as List?)
          ?.map((tracker) => Tracker.fromJson(tracker))
          .toList(),
      trackerList: rawData[TorrentGetArgument.trackerList.argName] as String?,
      trackerStats: (rawData[TorrentGetArgument.trackerStats.argName] as List?)
          ?.map((trackerStat) => TrackerStat.fromJson(trackerStat))
          .toList(),
      totalSize: rawData[TorrentGetArgument.totalSize.argName] as num?,
      torrentFile: rawData[TorrentGetArgument.torrentFile.argName] as String?,
      uploadedEver: rawData[TorrentGetArgument.uploadedEver.argName] as num?,
      uploadLimit: rawData[TorrentGetArgument.uploadLimit.argName] as num?,
      uploadLimited: rawData[TorrentGetArgument.uploadLimited.argName] as bool?,
      uploadRatio: rawData[TorrentGetArgument.uploadRatio.argName] as num?,
      wanted: buildWanted(rawData[TorrentGetArgument.wanted.argName] as List?),
      webseeds: (rawData[TorrentGetArgument.webseeds.argName] as List?)
          ?.map((webseed) => webseed as String)
          .toList(),
      webseedsSendingToUs:
          rawData[TorrentGetArgument.webseedsSendingToUs.argName] as num?,
    );
  }
}

class TorrentGetResponseParam implements ResponseParam {
  final List<TorrentId> removed;
  final List<TorrentInfo> torrents;

  const TorrentGetResponseParam(
      {required this.torrents, this.removed = const []});

  factory TorrentGetResponseParam.fromJson(rawData) {
    final rawRemoved = rawData["removed"];
    final rawTorrents = rawData["torrents"];
    final List<TorrentId> removed = rawRemoved is List
        ? rawRemoved.map((e) => TorrentId(id: (e as num).toInt())).toList()
        : const <TorrentId>[];
    final List<TorrentInfo> torrents = rawTorrents is List
        ? rawTorrents
            .whereType<JsonMap>()
            .map((e) => TorrentInfo.fromJson(e))
            .toList()
        : const <TorrentInfo>[];
    return TorrentGetResponseParam(torrents: torrents, removed: removed);
  }
}
