// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_transmission_rpc/src/model/session_get.dart';
import 'package:flutter_transmission_rpc/src/exception.dart';
import 'package:flutter_transmission_rpc/src/version.dart';
import 'package:test/test.dart';

void testSessionGetRequestParam() => group("test SessionGetRequestParam", () {
      group("factory constructor: build", () {
        test("test no version", () {
          final p = SessionGetRequestParam.build();
          expect(p.runtimeType.toString(), "_SessionGetRequestParam");
        });
        test("test basic", () {
          final v = ServerRpcVersion.build(
              kMinimumSupportRpcVersion, kMinimumSupportRpcVersion);
          final p = SessionGetRequestParam.build(version: v);
          expect(p.runtimeType.toString(), "_SessionGetRequestParam");
        });
        test("test API compatible rpc-version 16", () {
          final v = ServerRpcVersion.build(16, kMinimumSupportRpcVersion);
          final p = SessionGetRequestParam.build(version: v);
          expect(p.runtimeType.toString(), "_SessionGetRequestPramRpc16");
        });

        test("test API compatible rpc-version 17", () {
          final v = ServerRpcVersion.build(17, kMinimumSupportRpcVersion);
          final p = SessionGetRequestParam.build(version: v);
          expect(p.runtimeType.toString(), "_SessionGetRequestPramRpc17");
        });

        test("test invalid API version", () {
          final v = ServerRpcVersion.build(kMinimumSupportRpcVersion - 1, 1);
          expect(
              () => SessionGetRequestParam.build(version: v),
              throwsA(predicate((e) =>
                  e is TransmissionVersionError &&
                  e.reason == "Incompatible API version on session-get")));
        });
        test("test invalid API version - negative rpc version", () {
          final v = ServerRpcVersion.build(-1, -1);
          expect(
              () => SessionGetRequestParam.build(version: v),
              throwsA(predicate((e) =>
                  e is TransmissionVersionError &&
                  e.reason == "Incompatible API version on session-get")));
        });

        test("test invalid API version - negative min rpc version", () {
          final v = ServerRpcVersion.build(1, -1);
          expect(
              () => SessionGetRequestParam.build(version: v),
              throwsA(predicate((e) =>
                  e is TransmissionVersionError &&
                  e.reason == "Incompatible API version on session-get")));
        });
      });
    });

void testSessionGetRequestParamImp() {
  _testSessionGetRequestParamImp();
  _testSessionGetRequestParamRpc16Imp();
  _testSessionGetRequestParamRpc17Imp();
}

void _testSessionGetRequestParamImp() =>
    group("test _SessionGetRequestParam", () {
      group("method: check", () {
        test("no fields", () {
          final p = SessionGetRequestParam.build();
          final r = p.check();
          expect(r, null);
        });
        test("with empty fields", () {
          final p = SessionGetRequestParam.build(fields: []);
          final r = p.check();
          expect(r!.isNotEmpty, true);
        });
        test("with fields", () {
          final p = SessionGetRequestParam.build(fields: [
            SessionGetArgument.version,
          ]);
          final r = p.check();
          expect(r!.isNotEmpty, true);
        });
      });
      group("method: toRpcJson", () {
        test("no field", () {
          final p = SessionGetRequestParam.build();
          final r = p.toRpcJson();
          expect(r, {});
        });
        test("with field", () {
          final p = SessionGetRequestParam.build(fields: [
            SessionGetArgument.version,
          ]);
          final r = p.toRpcJson();
          expect(r, {});
        });
      });
    });

void _testSessionGetRequestParamRpc16Imp() =>
    group("test _SessionGetRequestPramRpc16", () {
      group("method: check", () {
        final sv = ServerRpcVersion.build(16, 14);
        setUp(() {
          final testP = SessionGetRequestParam.build(version: sv);
          expect(testP.runtimeType.toString(), "_SessionGetRequestPramRpc16");
        });
        test("no fields", () {
          final p = SessionGetRequestParam.build(version: sv);
          final r = p.check();
          expect(r, null);
        });
        test("with empty fields", () {
          final p = SessionGetRequestParam.build(version: sv, fields: []);
          final r = p.check();
          expect(r, null);
        });
        test("with fields", () {
          final p = SessionGetRequestParam.build(version: sv, fields: [
            SessionGetArgument.version,
          ]);
          final r = p.check();
          expect(r, null);
        });
        test("with un-support fields", () {
          final p = SessionGetRequestParam.build(
              version: sv, fields: SessionGetArgument.values);
          final r = p.check()!;
          expect(r.isNotEmpty, true);
          expect(r.startsWith("got possibly imcompatible fields"), true);
        });
      });
      group("method: toRpcJson", () {
        final sv = ServerRpcVersion.build(16, 14);
        setUp(() {
          final testP = SessionGetRequestParam.build(version: sv);
          expect(testP.runtimeType.toString(), "_SessionGetRequestPramRpc16");
        });
        test("no fields", () {
          final p = SessionGetRequestParam.build(version: sv);
          final r = p.toRpcJson();
          expect(r, {});
        });
        test("with empty fields", () {
          final p = SessionGetRequestParam.build(version: sv, fields: []);
          final r = p.toRpcJson();
          expect(r, {'fields': []});
        });
        test("with fields", () {
          final p = SessionGetRequestParam.build(version: sv, fields: [
            SessionGetArgument.version,
          ]);
          final r = p.toRpcJson();
          expect(r, {
            'fields': [
              SessionGetArgument.version.argName,
            ]
          });
        });
        test("with un-support fields", () {
          final p = SessionGetRequestParam.build(
              version: sv, fields: SessionGetArgument.values);
          final r = p.toRpcJson();
          expect(
              (r["fields"] as List<String>)
                  .contains(SessionGetArgument.version.argName),
              true);
          expect(
              (r["fields"] as List<String>)
                  .contains(SessionGetArgument.defaultTrackers.argName),
              false);
        });
      });
    });

void _testSessionGetRequestParamRpc17Imp() =>
    group("test _SessionGetRequestPramRpc17", () {
      group("method: check", () {
        final sv = ServerRpcVersion.build(17, 14);
        setUp(() {
          final testP = SessionGetRequestParam.build(version: sv);
          expect(testP.runtimeType.toString(), "_SessionGetRequestPramRpc17");
        });
        test("with fields", () {
          final p = SessionGetRequestParam.build(
              version: sv,
              fields: SessionGetArgument.values
                  .where((e) => e != SessionGetArgument.downloadDirFreeSpace)
                  .toList());
          final r = p.check();
          expect(r, null);
        });

        test("with un-support fields", () {
          final p = SessionGetRequestParam.build(
              version: sv, fields: SessionGetArgument.values);
          final r = p.check()!;
          expect(r.isNotEmpty, true);
          expect(r.startsWith("got possibly imcompatible fields"), true);
        });
      });
    });

void testSessionUnits() => group("test SessionUnits", () {
      test("constructor ()", () {
        const su = SessionUnits(
          speedUnits: ["a", "b"],
          speedBytes: 10,
          sizeUnits: ["c", "d"],
          sizeBytes: 100,
          memoryUnits: ["x", "y"],
          memoryBytes: 1000,
        );
        expect(su.speedUnits, ["a", "b"]);
        expect(su.speedBytes, 10);
        expect(su.sizeUnits, ["c", "d"]);
        expect(su.sizeBytes, 100);
        expect(su.memoryUnits, ["x", "y"]);
        expect(su.memoryBytes, 1000);
      });
      test("factory constructor: fromJson", () {
        Map<String, dynamic> jsonData = {
          "speed-units": ["a", "b"],
          "speed-bytes": 10,
          "size-units": ["c", "d"],
          "size-bytes": 100,
          "memory-units": ["x", "y"],
          "memory-bytes": 1000,
        };
        final su = SessionUnits.fromJson(jsonData);
        expect(su.speedUnits, ["a", "b"]);
        expect(su.speedBytes, 10);
        expect(su.sizeUnits, ["c", "d"]);
        expect(su.sizeBytes, 100);
        expect(su.memoryUnits, ["x", "y"]);
        expect(su.memoryBytes, 1000);
      });
    });

void testSessionGetResponseParam() => group("test SessionGetResponseParam", () {
      void checkAllAtrributesAreNull(SessionGetResponseParam sessionParam) {
        expect(sessionParam.altSpeedDown, isNull);
        expect(sessionParam.altSpeedEnabled, isNull);
        expect(sessionParam.altSpeedTimeBegin, isNull);
        expect(sessionParam.altSpeedTimeDay, isNull);
        expect(sessionParam.altSpeedTimeEnabled, isNull);
        expect(sessionParam.altSpeedTimeEnd, isNull);
        expect(sessionParam.altSpeedUp, isNull);
        expect(sessionParam.blocklistEnabled, isNull);
        expect(sessionParam.blocklistSize, isNull);
        expect(sessionParam.blocklistUrl, isNull);
        expect(sessionParam.cacheSizeMb, isNull);
        expect(sessionParam.configDir, isNull);
        expect(sessionParam.defaultTrackers, isNull);
        expect(sessionParam.dhtEnabled, isNull);
        expect(sessionParam.downloadDir, isNull);
        expect(sessionParam.downloadDirFreeSpace, isNull);
        expect(sessionParam.downloadQueueEnabled, isNull);
        expect(sessionParam.downloadQueueSize, isNull);
        expect(sessionParam.encryption, isNull);
        expect(sessionParam.idleSeedingLimitEnabled, isNull);
        expect(sessionParam.idleSeedingLimit, isNull);
        expect(sessionParam.incompleteDirEnabled, isNull);
        expect(sessionParam.incompleteDir, isNull);
        expect(sessionParam.lpdEnabled, isNull);
        expect(sessionParam.peerLimitGlobal, isNull);
        expect(sessionParam.peerLimitPerTorrent, isNull);
        expect(sessionParam.peerPortRandomOnStart, isNull);
        expect(sessionParam.peerPort, isNull);
        expect(sessionParam.pexEnabled, isNull);
        expect(sessionParam.portForwardingEnabled, isNull);
        expect(sessionParam.queueStalledEnabled, isNull);
        expect(sessionParam.queueStalledMinutes, isNull);
        expect(sessionParam.renamePartialFiles, isNull);
        expect(sessionParam.rpcVersionMinimum, isNull);
        expect(sessionParam.rpcVersionSemver, isNull);
        expect(sessionParam.rpcVersion, isNull);
        expect(sessionParam.scriptTorrentAddedEnabled, isNull);
        expect(sessionParam.scriptTorrentAddedFilename, isNull);
        expect(sessionParam.scriptTorrentDoneEnabled, isNull);
        expect(sessionParam.scriptTorrentDoneFilename, isNull);
        expect(sessionParam.scriptTorrentDoneSeedingEnabled, isNull);
        expect(sessionParam.scriptTorrentDoneSeedingFilename, isNull);
        expect(sessionParam.seedQueueEnabled, isNull);
        expect(sessionParam.seedQueueSize, isNull);
        expect(sessionParam.seedRatioLimit, isNull);
        expect(sessionParam.seedRatioLimited, isNull);
        expect(sessionParam.sessionId, isNull);
        expect(sessionParam.speedLimitDownEnabled, isNull);
        expect(sessionParam.speedLimitDown, isNull);
        expect(sessionParam.speedLimitUpEnabled, isNull);
        expect(sessionParam.speedLimitUp, isNull);
        expect(sessionParam.startAddedTorrents, isNull);
        expect(sessionParam.trashOriginalTorrentFiles, isNull);
        expect(sessionParam.units, isNull);
        expect(sessionParam.utpEnabled, isNull);
        expect(sessionParam.version, isNull);
      }

      group("constructor: ()", () {
        test("empty args", () {
          final p = SessionGetResponseParam();
          checkAllAtrributesAreNull(p);
        });
        test("some args", () {
          final p = SessionGetResponseParam(rpcVersion: 10);
          expect(p.rpcVersion, 10);
          expect(p.version, isNull);
        });
      });
      group("factory constructor: fromJson", () {
        test("empty args", () {
          final p = SessionGetResponseParam.fromJson({});
          checkAllAtrributesAreNull(p);
        });
        test("some args", () {
          final p = SessionGetResponseParam.fromJson(
              {SessionGetArgument.rpcVersion.argName: 10});
          expect(p.rpcVersion, 10);
          expect(p.version, isNull);
        });
        test("all args", () {
          final jsonData = {
            SessionGetArgument.altSpeedDown.argName: 50,
            SessionGetArgument.altSpeedEnabled.argName: true,
            SessionGetArgument.altSpeedTimeBegin.argName: 3600,
            SessionGetArgument.altSpeedTimeDay.argName: 2,
            SessionGetArgument.altSpeedTimeEnabled.argName: false,
            SessionGetArgument.altSpeedTimeEnd.argName: 7200,
            SessionGetArgument.altSpeedUp.argName: 100,
            SessionGetArgument.blocklistEnabled.argName: true,
            SessionGetArgument.blocklistSize.argName: 500,
            SessionGetArgument.blocklistUrl.argName:
                "https://example.com/blocklist.txt",
            SessionGetArgument.cacheSizeMb.argName: 256,
            SessionGetArgument.configDir.argName: "/path/to/config",
            SessionGetArgument.defaultTrackers.argName:
                "https://tracker1.com,https://tracker2.com",
            SessionGetArgument.dhtEnabled.argName: true,
            SessionGetArgument.downloadDir.argName: "/path/to/downloads",
            SessionGetArgument.downloadDirFreeSpace.argName: 1024,
            SessionGetArgument.downloadQueueEnabled.argName: false,
            SessionGetArgument.downloadQueueSize.argName: 5,
            SessionGetArgument.encryption.argName: "AES-256",
            SessionGetArgument.idleSeedingLimitEnabled.argName: true,
            SessionGetArgument.idleSeedingLimit.argName: 30,
            SessionGetArgument.incompleteDirEnabled.argName: true,
            SessionGetArgument.incompleteDir.argName: "/path/to/incomplete",
            SessionGetArgument.lpdEnabled.argName: false,
            SessionGetArgument.peerLimitGlobal.argName: 200,
            SessionGetArgument.peerLimitPerTorrent.argName: 50,
            SessionGetArgument.peerPortRandomOnStart.argName: true,
            SessionGetArgument.peerPort.argName: 6881,
            SessionGetArgument.pexEnabled.argName: true,
            SessionGetArgument.portForwardingEnabled.argName: true,
            SessionGetArgument.queueStalledEnabled.argName: true,
            SessionGetArgument.queueStalledMinutes.argName: 15,
            SessionGetArgument.renamePartialFiles.argName: false,
            SessionGetArgument.rpcVersionMinimum.argName: 1,
            SessionGetArgument.rpcVersionSemver.argName: "2.0.0",
            SessionGetArgument.rpcVersion.argName: 2,
            SessionGetArgument.scriptTorrentAddedEnabled.argName: false,
            SessionGetArgument.scriptTorrentAddedFilename.argName:
                "script_added.sh",
            SessionGetArgument.scriptTorrentDoneEnabled.argName: true,
            SessionGetArgument.scriptTorrentDoneFilename.argName:
                "script_done.sh",
            SessionGetArgument.scriptTorrentDoneSeedingEnabled.argName: false,
            SessionGetArgument.scriptTorrentDoneSeedingFilename.argName:
                "script_done_seeding.sh",
            SessionGetArgument.seedQueueEnabled.argName: true,
            SessionGetArgument.seedQueueSize.argName: 10,
            SessionGetArgument.seedRatioLimit.argName: 2.0,
            SessionGetArgument.seedRatioLimited.argName: true,
            SessionGetArgument.sessionId.argName: "session_id_123",
            SessionGetArgument.speedLimitDownEnabled.argName: true,
            SessionGetArgument.speedLimitDown.argName: 1000,
            SessionGetArgument.speedLimitUpEnabled.argName: true,
            SessionGetArgument.speedLimitUp.argName: 500,
            SessionGetArgument.startAddedTorrents.argName: false,
            SessionGetArgument.trashOriginalTorrentFiles.argName: true,
            SessionGetArgument.units.argName: {
              "speed-units": ["MB/s", "KB/s"],
              "speed-bytes": 1024,
              "size-units": ["GB", "MB"],
              "size-bytes": 1048576,
              "memory-units": ["GB", "MB"],
              "memory-bytes": 1073741824,
            },
            SessionGetArgument.utpEnabled.argName: false,
            SessionGetArgument.version.argName: "3.0.1",
          };
          final p = SessionGetResponseParam.fromJson(jsonData);

          expect(p.altSpeedDown, equals(50));
          expect(p.altSpeedEnabled, equals(true));
          expect(p.altSpeedTimeBegin, equals(3600));
          expect(p.altSpeedTimeDay, equals(2));
          expect(p.altSpeedTimeEnabled, equals(false));
          expect(p.altSpeedTimeEnd, equals(7200));
          expect(p.altSpeedUp, equals(100));
          expect(p.blocklistEnabled, equals(true));
          expect(p.blocklistSize, equals(500));
          expect(p.blocklistUrl, equals("https://example.com/blocklist.txt"));
          expect(p.cacheSizeMb, equals(256));
          expect(p.configDir, equals("/path/to/config"));
          expect(p.defaultTrackers,
              equals("https://tracker1.com,https://tracker2.com"));
          expect(p.dhtEnabled, equals(true));
          expect(p.downloadDir, equals("/path/to/downloads"));
          expect(p.downloadDirFreeSpace, equals(1024));
          expect(p.downloadQueueEnabled, equals(false));
          expect(p.downloadQueueSize, equals(5));
          expect(p.encryption, equals("AES-256"));
          expect(p.idleSeedingLimitEnabled, equals(true));
          expect(p.idleSeedingLimit, equals(30));
          expect(p.incompleteDirEnabled, equals(true));
          expect(p.incompleteDir, equals("/path/to/incomplete"));
          expect(p.lpdEnabled, equals(false));
          expect(p.peerLimitGlobal, equals(200));
          expect(p.peerLimitPerTorrent, equals(50));
          expect(p.peerPortRandomOnStart, equals(true));
          expect(p.peerPort, equals(6881));
          expect(p.pexEnabled, equals(true));
          expect(p.portForwardingEnabled, equals(true));
          expect(p.queueStalledEnabled, equals(true));
          expect(p.queueStalledMinutes, equals(15));
          expect(p.renamePartialFiles, equals(false));
          expect(p.rpcVersionMinimum, equals(1));
          expect(p.rpcVersionSemver, equals("2.0.0"));
          expect(p.rpcVersion, equals(2));
          expect(p.scriptTorrentAddedEnabled, equals(false));
          expect(p.scriptTorrentAddedFilename, equals("script_added.sh"));
          expect(p.scriptTorrentDoneEnabled, equals(true));
          expect(p.scriptTorrentDoneFilename, equals("script_done.sh"));
          expect(p.scriptTorrentDoneSeedingEnabled, equals(false));
          expect(p.scriptTorrentDoneSeedingFilename,
              equals("script_done_seeding.sh"));
          expect(p.seedQueueEnabled, equals(true));
          expect(p.seedQueueSize, equals(10));
          expect(p.seedRatioLimit, equals(2.0));
          expect(p.seedRatioLimited, equals(true));
          expect(p.sessionId, equals("session_id_123"));
          expect(p.speedLimitDownEnabled, equals(true));
          expect(p.speedLimitDown, equals(1000));
          expect(p.speedLimitUpEnabled, equals(true));
          expect(p.speedLimitUp, equals(500));
          expect(p.startAddedTorrents, equals(false));
          expect(p.trashOriginalTorrentFiles, equals(true));
          expect(p.units.runtimeType, SessionUnits);
          expect(p.units!.speedUnits, equals(["MB/s", "KB/s"]));
          expect(p.units!.speedBytes, equals(1024));
          expect(p.units!.sizeUnits, equals(["GB", "MB"]));
          expect(p.units!.sizeBytes, equals(1048576));
          expect(p.units!.memoryUnits, equals(["GB", "MB"]));
          expect(p.units!.memoryBytes, equals(1073741824));
          expect(p.utpEnabled, equals(false));
          expect(p.version, equals("3.0.1"));
        });
      });
    });

void main() {
  testSessionGetRequestParam();
  testSessionGetRequestParamImp();
  testSessionUnits();
  testSessionGetResponseParam();
}
