// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';

enum SessionStatArgument {
  activeTorrentCount(argName: "activeTorrentCount"),
  downloadSpeed(argName: "downloadSpeed"),
  pausedTorrentCount(argName: "pausedTorrentCount"),
  torrentCount(argName: "torrentCount"),
  uploadSpeed(argName: "uploadSpeed"),
  cumulativeStats(argName: "cumulative-stats"),
  currentStats(argName: "current-stats");

  final String argName;

  const SessionStatArgument({required this.argName});
}

class SessionStatsRequestParam implements RequestParam {
  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {};
}

class Stats {
  final num uploadedBytes;
  final num downloadedBytes;
  final num filesAdded;
  final num sessionCount;
  final num secondsActive;

  const Stats({
    required this.uploadedBytes,
    required this.downloadedBytes,
    required this.filesAdded,
    required this.sessionCount,
    required this.secondsActive,
  });

  factory Stats.fromJson(JsonMap rawData) {
    return Stats(
      uploadedBytes: rawData["uploadedBytes"] as num,
      downloadedBytes: rawData["downloadedBytes"] as num,
      filesAdded: rawData["filesAdded"] as num,
      sessionCount: rawData["sessionCount"] as num,
      secondsActive: rawData["secondsActive"] as num,
    );
  }
}

class SessionStatsResponseParam implements ResponseParam {
  final num activeTorrentCount;
  final num downloadSpeed;
  final num pausedTorrentCount;
  final num torrentCount;
  final num uploadSpeed;
  final Stats cumulativeStats;
  final Stats currentStats;

  const SessionStatsResponseParam({
    required this.activeTorrentCount,
    required this.downloadSpeed,
    required this.pausedTorrentCount,
    required this.torrentCount,
    required this.uploadSpeed,
    required this.cumulativeStats,
    required this.currentStats,
  });

  factory SessionStatsResponseParam.fromJson(JsonMap rawData) {
    return SessionStatsResponseParam(
      activeTorrentCount:
          rawData[SessionStatArgument.activeTorrentCount.argName] as num,
      downloadSpeed: rawData[SessionStatArgument.downloadSpeed.argName] as num,
      pausedTorrentCount:
          rawData[SessionStatArgument.pausedTorrentCount.argName] as num,
      torrentCount: rawData[SessionStatArgument.torrentCount.argName] as num,
      uploadSpeed: rawData[SessionStatArgument.uploadSpeed.argName] as num,
      cumulativeStats:
          Stats.fromJson(rawData[SessionStatArgument.cumulativeStats.argName]),
      currentStats:
          Stats.fromJson(rawData[SessionStatArgument.currentStats.argName]),
    );
  }
}
