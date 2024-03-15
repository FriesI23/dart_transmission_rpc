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
import '../version.dart';
import 'torrent.dart';

enum TorrentGetArgument {
  activityDate(argName: "activityDate"),
  addedDate(argName: "addedDate"),
  availability(argName: "availability"),
  bandwidthPriority(argName: "bandwidthPriority"),
  comment(argName: "comment"),
  corruptEver(argName: "corruptEver"),
  creator(argName: "creator"),
  dateCreated(argName: "dateCreated"),
  desiredAvailable(argName: "desiredAvailable"),
  doneDate(argName: "doneDate"),
  downloadDir(argName: "downloadDir"),
  downloadedEver(argName: "downloadedEver"),
  downloadLimit(argName: "downloadLimit"),
  downloadLimited(argName: "downloadLimited"),
  editDate(argName: "editDate"),
  error(argName: "error"),
  errorString(argName: "errorString"),
  eta(argName: "eta"),
  etaIdle(argName: "etaIdle"),
  fileCount(argName: "file-count"),
  files(argName: "files"),
  fileStats(argName: "fileStats"),
  group(argName: "group"),
  hashString(argName: "hashString"),
  haveUnchecked(argName: "haveUnchecked"),
  haveValid(argName: "haveValid"),
  honorsSessionLimits(argName: "honorsSessionLimits"),
  id(argName: "id"),
  isFinished(argName: "isFinished"),
  isPrivate(argName: "isPrivate"),
  isStalled(argName: "isStalled"),
  labels(argName: "labels"),
  leftUntilDone(argName: "leftUntilDone"),
  magnetLink(argName: "magnetLink"),
  manualAnnounceTime(argName: "manualAnnounceTime"),
  maxConnectedPeers(argName: "maxConnectedPeers"),
  metadataPercentComplete(argName: "metadataPercentComplete"),
  name(argName: "name"),
  peerLimit(argName: "peer-limit"),
  peers(argName: "peers"),
  peersConnected(argName: "peersConnected"),
  peersFrom(argName: "peersFrom"),
  peersGettingFromUs(argName: "peersGettingFromUs"),
  peersSendingToUs(argName: "peersSendingToUs"),
  percentComplete(argName: "percentComplete"),
  percentDone(argName: "percentDone"),
  pieces(argName: "pieces"),
  pieceCount(argName: "pieceCount"),
  pieceSize(argName: "pieceSize"),
  priorities(argName: "priorities"),
  primaryMimeType(argName: "primary-mime-type"),
  queuePosition(argName: "queuePosition"),
  rateDownload(argName: "rateDownload"),
  rateUpload(argName: "rateUpload"),
  recheckProgress(argName: "recheckProgress"),
  secondsDownloading(argName: "secondsDownloading"),
  secondsSeeding(argName: "secondsSeeding"),
  seedIdleLimit(argName: "seedIdleLimit"),
  seedIdleMode(argName: "seedIdleMode"),
  seedRatioLimit(argName: "seedRatioLimit"),
  seedRatioMode(argName: "seedRatioMode"),
  sequentialDownload(argName: "sequentialDownload"),
  sizeWhenDone(argName: "sizeWhenDone"),
  startDate(argName: "startDate"),
  status(argName: "status"),
  trackers(argName: "trackers"),
  trackerList(argName: "trackerList"),
  trackerStats(argName: "trackerStats"),
  totalSize(argName: "totalSize"),
  torrentFile(argName: "torrentFile"),
  uploadedEver(argName: "uploadedEver"),
  uploadLimit(argName: "uploadLimit"),
  uploadLimited(argName: "uploadLimited"),
  uploadRatio(argName: "uploadRatio"),
  wanted(argName: "wanted"),
  webseeds(argName: "webseeds"),
  webseedsSendingToUs(argName: "webseedsSendingToUs");

  final String argName;

  const TorrentGetArgument({required this.argName});
}

abstract class TorrentGetRequestParam implements RequestParam {
  final List<TorrentGetArgument>? fields;
  final TorrentIds? ids;

  const TorrentGetRequestParam(this.fields, this.ids);

  factory TorrentGetRequestParam.build({
    ServerRpcVersion? version,
    required List<TorrentGetArgument>? fields,
    TorrentIds? ids,
  }) {
    if (version == null) {
      return _TorrentGetRequestParam(fields, ids);
    } else if (version.checkApiVersionValidate(v: 18)) {
      return _TorrentGetRequestParamRpc18(fields, ids);
    } else if (version.checkApiVersionValidate(v: 17)) {
      return _TorrentGetRequestParamRpc17(fields, ids);
    } else if (version.checkApiVersionValidate(v: 16)) {
      return _TorrentGetRequestParamRpc16(fields, ids);
    } else if (version.checkApiVersionValidate(v: 15)) {
      return _TorrentGetRequestParamRpc15(fields, ids);
    } else if (version.checkApiVersionValidate()) {
      return _TorrentGetRequestParam(fields, ids);
    } else {
      throw TransmissionVersionError("Incompatible API version on session-get",
          version.rpcVersion, version.minRpcVersion);
    }
  }

  Set<TorrentGetArgument> get allowedFields;
  Set<TorrentGetArgument> get deprecatedFields;

  @override
  String? check() {
    if (fields == null) return null;
    if (fields!.isEmpty) {
      throw const TransmissionCheckError("fields should not be empty");
    }
    final Set<TorrentGetArgument> mFields = {};
    final Set<TorrentGetArgument> dFields = {};
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
        "fields": (fields != null
                ? fields!.where((e) => allowedFields.contains(e))
                : allowedFields)
            .map((e) => e.argName)
            .toList(),
        if (ids != null && ids!.isNotEmpty) "ids": ids!.toRpcJson(),
      };
}

class _TorrentGetRequestParam extends TorrentGetRequestParam {
  static const _allowedFields = {
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

class _TorrentGetRequestParamRpc15 extends TorrentGetRequestParam {
  static const _allowedFields = {
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
    // rpc15 new
    TorrentGetArgument.etaIdle,
  };

  const _TorrentGetRequestParamRpc15(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentGetArgument> get deprecatedFields => {};
}

class _TorrentGetRequestParamRpc16 extends _TorrentGetRequestParamRpc15 {
  static const _allowedFields = {
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
    // rpc15 new
    TorrentGetArgument.etaIdle,
    // rpc16 new
    TorrentGetArgument.labels,
    TorrentGetArgument.editDate,
  };

  const _TorrentGetRequestParamRpc16(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentGetArgument> get deprecatedFields => {};

  @override
  JsonMap toRpcJson() {
    // TODO: use "table" format request and handle result
    JsonMap data = super.toRpcJson();
    data["format"] = "objects";
    return data;
  }
}

class _TorrentGetRequestParamRpc17 extends _TorrentGetRequestParamRpc16 {
  static const _allowedFields = {
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
    // rpc15 new
    TorrentGetArgument.etaIdle,
    // rpc16 new
    TorrentGetArgument.labels,
    TorrentGetArgument.editDate,
    // rpc17 new
    TorrentGetArgument.availability,
    TorrentGetArgument.fileCount,
    TorrentGetArgument.group,
    TorrentGetArgument.percentComplete,
    TorrentGetArgument.primaryMimeType,
    TorrentGetArgument.trackerList,
  };

  const _TorrentGetRequestParamRpc17(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentGetArgument> get deprecatedFields => {};
}

class _TorrentGetRequestParamRpc18 extends _TorrentGetRequestParamRpc17 {
  static const _allowedFields = {
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
    // rpc15 new
    TorrentGetArgument.etaIdle,
    // rpc16 new
    TorrentGetArgument.labels,
    TorrentGetArgument.editDate,
    // rpc17 new
    TorrentGetArgument.availability,
    TorrentGetArgument.fileCount,
    TorrentGetArgument.group,
    TorrentGetArgument.percentComplete,
    TorrentGetArgument.primaryMimeType,
    TorrentGetArgument.trackerList,
    // rpc18 new
    TorrentGetArgument.sequentialDownload,
  };

  const _TorrentGetRequestParamRpc18(super.fields, super.ids);

  @override
  Set<TorrentGetArgument> get allowedFields => _allowedFields;

  @override
  Set<TorrentGetArgument> get deprecatedFields => {};
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

enum TorrentStatus {
  stopped(0),
  queuedToVerify(1),
  verifyLocalData(2),
  queuedToDownload(3),
  downloading(4),
  queuedToSeed(5),
  seeding(6);

  final int val;

  const TorrentStatus(this.val);

  factory TorrentStatus.fromVal(int val) {
    switch (val) {
      case 0:
        return TorrentStatus.stopped;
      case 1:
        return TorrentStatus.queuedToVerify;
      case 2:
        return TorrentStatus.verifyLocalData;
      case 3:
        return TorrentStatus.queuedToDownload;
      case 4:
        return TorrentStatus.downloading;
      case 5:
        return TorrentStatus.queuedToSeed;
      case 6:
        return TorrentStatus.seeding;
      default:
        throw ArgumentError("Invalid TorrentStatus value: $val");
    }
  }
}

class Tracker {
  final String announce;
  final num id;
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
  final num id;
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
      lastAnnounceTimedOut: rawData['lastAnnounceTimedOut'] as bool,
      lastScrapeResult: rawData['lastScrapeResult'] as String,
      lastScrapeStartTime: rawData['lastScrapeStartTime'] as num,
      lastScrapeSucceeded: rawData['lastScrapeSucceeded'] as bool,
      lastScrapeTime: rawData['lastScrapeTime'] as num,
      lastScrapeTimedOut: rawData['lastScrapeTimedOut'] as bool,
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
  final String? hashString;
  final num? haveUnchecked;
  final num? haveValid;
  final bool? honorsSessionLimits;
  final num? id;
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
  final num? seedIdleMode;
  final num? seedRatioLimit;
  final num? seedRatioMode;
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
    this.hashString,
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
      hashString: rawData[TorrentGetArgument.hashString.argName] as String?,
      haveUnchecked: rawData[TorrentGetArgument.haveUnchecked.argName] as num?,
      haveValid: rawData[TorrentGetArgument.haveValid.argName] as num?,
      honorsSessionLimits:
          rawData[TorrentGetArgument.honorsSessionLimits.argName] as bool?,
      id: rawData[TorrentGetArgument.id.argName] as num?,
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
      seedIdleMode: rawData[TorrentGetArgument.seedIdleMode.argName] as num?,
      seedRatioLimit:
          rawData[TorrentGetArgument.seedRatioLimit.argName] as num?,
      seedRatioMode: rawData[TorrentGetArgument.seedRatioMode.argName] as num?,
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
