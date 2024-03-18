// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:io';

import 'package:dart_transmission_rpc/model.dart';
import 'package:dart_transmission_rpc/utils.dart';
import 'package:test/test.dart';

final testFileInfo = TorrentAddFileInfo(
  filename: "example.torrent",
  metainfo: utf8.encode("example metainfo"),
);

TorrentAddRequestArgs buildTestingUseNoNullArgs() => TorrentAddRequestArgs(
    fileInfo: testFileInfo,
    cookies: [Cookie("session_id", "123456")],
    downloadDir: "/downloads",
    paused: false,
    peerLimit: 100,
    bandwidthPriority: 1,
    filesWanted: FileIndices([1, 2, 3]),
    filesUnwanted: FileIndices([4, 5]),
    priorityHigh: FileIndices([1, 3]),
    priorityLow: FileIndices([2, 4]),
    priorityNormal: FileIndices([5, 6]),
    labels: ["label1", "label2"]);

JsonMap buildTestingUseStructArgs() => {
      'cookies': 'session_id=123456; HttpOnly',
      'download-dir': '/downloads',
      'filename': testFileInfo.filename,
      'paused': false,
      'peer-limit': 100,
      'bandwidthPriority': 1,
      'files-wanted': [1, 2, 3],
      'files-unwanted': [4, 5],
      'priority-high': [1, 3],
      'priority-low': [2, 4],
      'priority-normal': [5, 6]
    };

class TorrentAddRequestParamStub extends TorrentAddRequestParam {
  final JsonMap Function()? _toRpcJson;

  TorrentAddRequestParamStub({
    required super.args,
    this.allowedFields = const {},
    this.deprecatedFields = const {},
    JsonMap Function()? toRpcJson,
  }) : _toRpcJson = toRpcJson;

  @override
  final Set<TorrentAddArgument> allowedFields;

  @override
  final Set<TorrentAddArgument> deprecatedFields;

  @override
  JsonMap toRpcJson() => _toRpcJson?.call() ?? {};

  @override
  String? check() => null;
}

void testTorrentAddRequestArgs() => group("test TorrentAddRequestArgs", () {
      group("constructor: ()", () {
        test("with args", () {
          final args = TorrentAddRequestArgs(
            fileInfo: testFileInfo,
            cookies: [Cookie("session_id", "123456")],
            downloadDir: "/downloads",
            paused: false,
            peerLimit: 100,
            bandwidthPriority: 1,
            filesWanted: FileIndices([1, 2, 3]),
            filesUnwanted: FileIndices([4, 5]),
            priorityHigh: FileIndices([1, 3]),
            priorityLow: FileIndices([2, 4]),
            priorityNormal: FileIndices([5, 6]),
            labels: ["label1", "label2"],
          );
          expect(args.fileInfo.filename, "example.torrent");
          expect(args.fileInfo.metainfo, utf8.encode("example metainfo"));
          expect(args.cookies?.length, 1);
          expect(args.downloadDir, "/downloads");
          expect(args.paused, false);
          expect(args.peerLimit, 100);
          expect(args.bandwidthPriority, 1);
          expect(args.filesWanted?.indices, [1, 2, 3]);
          expect(args.filesUnwanted?.indices, [4, 5]);
          expect(args.priorityHigh?.indices, [1, 3]);
          expect(args.priorityLow?.indices, [2, 4]);
          expect(args.priorityNormal?.indices, [5, 6]);
          expect(args.labels, ["label1", "label2"]);
        });

        test("Get value by argument with empty arguments", () {
          final args = TorrentAddRequestArgs(
              fileInfo: TorrentAddFileInfo.byFilename("test"));
          expect(args.getValueByArgument(TorrentAddArgument.filename), "test");
          expect(args.getValueByArgument(TorrentAddArgument.metainfo), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.cookies), isNull);
          expect(
              args.getValueByArgument(TorrentAddArgument.downloadDir), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.paused), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.peerLimit), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.bandwidthPriority),
              isNull);
          expect(
              args.getValueByArgument(TorrentAddArgument.filesWanted), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.filesUnwanted),
              isNull);
          expect(
              args.getValueByArgument(TorrentAddArgument.priorityHigh), isNull);
          expect(
              args.getValueByArgument(TorrentAddArgument.priorityLow), isNull);
          expect(args.getValueByArgument(TorrentAddArgument.priorityNormal),
              isNull);
          expect(args.getValueByArgument(TorrentAddArgument.labels), isNull);
        });
        test("filename & metainfo", () {
          expect(() => TorrentAddRequestArgs(fileInfo: TorrentAddFileInfo()),
              throwsA(TypeMatcher<AssertionError>()));
        });
      });
      test("method: getValueByArgument", () {
        final args = TorrentAddRequestArgs(
          fileInfo: testFileInfo,
          cookies: [Cookie("session_id", "123456")],
          downloadDir: "/downloads",
          paused: false,
          peerLimit: 100,
          bandwidthPriority: 1,
          filesWanted: FileIndices([1, 2, 3]),
          filesUnwanted: FileIndices([4, 5]),
          priorityHigh: FileIndices([1, 3]),
          priorityLow: FileIndices([2, 4]),
          priorityNormal: FileIndices([5, 6]),
          labels: ["label1", "label2"],
        );

        expect(args.getValueByArgument(TorrentAddArgument.filename),
            testFileInfo.filename);
        expect(args.getValueByArgument(TorrentAddArgument.metainfo),
            testFileInfo.metainfo);
        expect(
            args.getValueByArgument(TorrentAddArgument.cookies), args.cookies);
        expect(args.getValueByArgument(TorrentAddArgument.downloadDir),
            "/downloads");
        expect(args.getValueByArgument(TorrentAddArgument.paused), false);
        expect(args.getValueByArgument(TorrentAddArgument.peerLimit), 100);
        expect(
            args.getValueByArgument(TorrentAddArgument.bandwidthPriority), 1);
        expect(args.getValueByArgument(TorrentAddArgument.filesWanted),
            args.filesWanted);
        expect(args.getValueByArgument(TorrentAddArgument.filesUnwanted),
            args.filesUnwanted);
        expect(args.getValueByArgument(TorrentAddArgument.priorityHigh),
            args.priorityHigh);
        expect(args.getValueByArgument(TorrentAddArgument.priorityLow),
            args.priorityLow);
        expect(args.getValueByArgument(TorrentAddArgument.priorityNormal),
            args.priorityNormal);
        expect(args.getValueByArgument(TorrentAddArgument.labels), args.labels);
      });
    });

void testTorrentAddRequestParam() => group("test TorrentAddRequestParam", () {
      TorrentAddRequestArgs? requestArgs;
      setUp(() {
        requestArgs = buildTestingUseNoNullArgs();
      });
      group("facotry constructor: build", () {
        test("no version", () {
          final p = TorrentAddRequestParam.build(args: requestArgs!);
          expect(p.runtimeType.toString(), "_TorrentAddRequestParam");
        });
        test("highest rpc", () {
          final p = TorrentAddRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(99, 1));
          expect(p.runtimeType.toString(), "_TorrentAddRequestParamRpc17");
        });
        test("rpc17", () {
          final p = TorrentAddRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(17, 1));
          expect(p.runtimeType.toString(), "_TorrentAddRequestParamRpc17");
        });
        test("default", () {
          final p = TorrentAddRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(15, 1));
          expect(p.runtimeType.toString(), "_TorrentAddRequestParam");
        });
        test("no version", () {
          expect(
              () => TorrentAddRequestParam.build(
                  args: requestArgs!,
                  version:
                      ServerRpcVersion.build(kMinimumSupportRpcVersion - 1, 1)),
              throwsA(TypeMatcher<TransmissionVersionError>()));
        });
      });
      test("override properties getter", () {
        final args = requestArgs!;
        final requestParam = TorrentAddRequestParamStub(args: args);

        expect(requestParam.cookies, args.cookies);
        expect(requestParam.fileInfo.filename, args.fileInfo.filename);
        expect(requestParam.fileInfo.metainfo, args.fileInfo.metainfo);
        expect(requestParam.downloadDir, args.downloadDir);
        expect(requestParam.paused, args.paused);
        expect(requestParam.peerLimit, args.peerLimit);
        expect(requestParam.bandwidthPriority, args.bandwidthPriority);
        expect(requestParam.filesWanted, args.filesWanted);
        expect(requestParam.filesUnwanted, args.filesUnwanted);
        expect(requestParam.priorityHigh, args.priorityHigh);
        expect(requestParam.priorityLow, args.priorityLow);
        expect(requestParam.priorityNormal, args.priorityNormal);
        expect(requestParam.labels, args.labels);
      });
    });

void testTorrentAddRequestParamImpl() =>
    group("test _TorrentAddRequestParam", () {
      final args = buildTestingUseNoNullArgs();
      TorrentAddRequestParam? p;
      setUp(() {
        p = TorrentAddRequestParam.build(args: args);
      });
      test("allowedFields", () {
        expect(p!.allowedFields, {
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
        });
      });
      test("check", () {
        final p1 = TorrentAddRequestParam.build(
            args: TorrentAddRequestArgs(
                fileInfo: TorrentAddFileInfo.byFilename("test")));
        expect(p1.check(), isNull);
        final p2 = TorrentAddRequestParam.build(
            args: TorrentAddRequestArgs(
                fileInfo: TorrentAddFileInfo.byFilename("test"),
                downloadDir: "ttt"));
        expect(p2.check(), isNull);
        final p3 = TorrentAddRequestParam.build(
            args: TorrentAddRequestArgs(
                fileInfo: TorrentAddFileInfo.byFilename("test"),
                labels: ["1", "2"]));
        expect(p3.check(), contains("prohibited"));
      });
      test("deprecatedFields", () {
        expect(p!.deprecatedFields.isEmpty, true);
      });
      group("toJson", () {
        test("struct", () {
          expect(p!.toRpcJson(), buildTestingUseStructArgs());
        });
        test("default", () {
          final p1 = TorrentAddRequestParam.build(
              args: TorrentAddRequestArgs(
                  fileInfo: TorrentAddFileInfo.byFilename("test")));
          expect(p1.toRpcJson(), {"filename": "test"});
          final p2 = TorrentAddRequestParam.build(
              args: TorrentAddRequestArgs(
            fileInfo: TorrentAddFileInfo.byMetainfo(utf8.encode("test2")),
          ));
          expect(p2.toRpcJson(), {"metainfo": 'dGVzdDI='});
        });
        test("with args", () {
          var r = p!.toRpcJson();
          for (var f in p!.allowedFields) {
            if (f == TorrentAddArgument.metainfo) continue;
            expect(r[f.argName], isNotNull, reason: "check field failed: $f");
            r.remove(f.argName);
          }
          expect(r.isEmpty, true, reason: "extra key: $r");
        });
      });
    });

void testTorrentAddRequestParamRpc17Impl() =>
    group("test _TorrentAddRequestParamRpc17", () {
      final args = buildTestingUseNoNullArgs();
      TorrentAddRequestParam? p;
      setUp(() {
        p = TorrentAddRequestParam.build(
            args: args, version: ServerRpcVersion.build(17, 1));
      });
      test("allowedFields", () {
        expect(p!.allowedFields, {
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
          TorrentAddArgument.labels, // rpc17
        });
      });
    });

void testTorrentAdded() => group("test TorrentAdded", () {
      test("factory constructor: fromJson", () {
        final rawData = {
          TorrentGetArgument.id.argName: 123,
          TorrentGetArgument.hashString.argName: "hash_string",
          TorrentGetArgument.name.argName: "torrent_name",
        };
        final torrentAdded = TorrentAdded.fromJson(rawData);
        expect(torrentAdded.id.id, equals(123));
        expect(torrentAdded.id.hashStr, equals("hash_string"));
        expect(torrentAdded.name, equals("torrent_name"));
      });
    });

void testTorrentAddResponseParam() => group("test TorrentAddResponseParam", () {
      final rawData = {
        "torrent-added": {
          TorrentGetArgument.id.argName: 123,
          TorrentGetArgument.hashString.argName: "hash_string_1",
          TorrentGetArgument.name.argName: "torrent_name_1",
        },
        "torrent-duplicate": {
          TorrentGetArgument.id.argName: 456,
          TorrentGetArgument.hashString.argName: "hash_string_2",
          TorrentGetArgument.name.argName: "torrent_name_2",
        },
      };
      group("factory constructor: fromJson", () {
        test("no version", () {
          final p = TorrentAddResponseParam.fromJson(rawData);
          expect(p.runtimeType.toString(), "_TorrentAddResponseParam");
        });
        test("highest version", () {
          final p = TorrentAddResponseParam.fromJson(rawData,
              version: ServerRpcVersion.build(99, 1));
          expect(p.runtimeType.toString(), "_TorrentAddResponseParamRpc15");
        });
        test("rpc15", () {
          final p = TorrentAddResponseParam.fromJson(rawData,
              version: ServerRpcVersion.build(15, 1));
          expect(p.runtimeType.toString(), "_TorrentAddResponseParamRpc15");
        });
        test("default", () {
          final p = TorrentAddResponseParam.fromJson(rawData,
              version: ServerRpcVersion.build(kMinimumSupportRpcVersion, 1));
          expect(p.runtimeType.toString(), "_TorrentAddResponseParam");
        });
        test("error", () {
          expect(
              () => TorrentAddResponseParam.fromJson(rawData,
                  version:
                      ServerRpcVersion.build(kMinimumSupportRpcVersion - 1, 1)),
              throwsA(TypeMatcher<TransmissionVersionError>()));
        });
      });
    });

void testTorrentAddResponseParamImpl() =>
    group("test _TorrentAddResponseParam", () {
      final rawData = {
        "torrent-added": {
          TorrentGetArgument.id.argName: 123,
          TorrentGetArgument.hashString.argName: "hash_string_1",
          TorrentGetArgument.name.argName: "torrent_name_1",
        },
      };
      final duplicateData = {
        "torrent-duplicate": {
          TorrentGetArgument.id.argName: 456,
          TorrentGetArgument.hashString.argName: "hash_string_2",
          TorrentGetArgument.name.argName: "torrent_name_2",
        },
      };
      final rawDataDuplicate = Map.of(rawData)..addAll(duplicateData);

      test("override properties", () {
        final p1 = TorrentAddResponseParam.fromJson(rawData);
        expect(p1.isDuplicated, false);
        expect(p1.torrent!.id.id, equals(123));
        expect(p1.torrent!.id.hashStr, equals("hash_string_1"));
        expect(p1.torrent!.name, equals("torrent_name_1"));
        final p2 = TorrentAddResponseParam.fromJson(duplicateData);
        expect(p2.isDuplicated, false);
        expect(p2.torrent, isNull);
        final p3 = TorrentAddResponseParam.fromJson(rawDataDuplicate);
        expect(p3.isDuplicated, false);
        expect(p3.torrent!.id.id, equals(123));
        expect(p3.torrent!.id.hashStr, equals("hash_string_1"));
        expect(p3.torrent!.name, equals("torrent_name_1"));
      });
    });

void testTorrentAddResponseParamRpc15Impl() =>
    group("test _TorrentAddResponseParam", () {
      final rawData = {
        "torrent-added": {
          TorrentGetArgument.id.argName: 123,
          TorrentGetArgument.hashString.argName: "hash_string_1",
          TorrentGetArgument.name.argName: "torrent_name_1",
        },
      };
      final duplicateData = {
        "torrent-duplicate": {
          TorrentGetArgument.id.argName: 456,
          TorrentGetArgument.hashString.argName: "hash_string_2",
          TorrentGetArgument.name.argName: "torrent_name_2",
        },
      };
      final rawDataDuplicate = Map.of(rawData)..addAll(duplicateData);

      test("override properties, normal", () {
        final p1 = TorrentAddResponseParam.fromJson(rawData,
            version: ServerRpcVersion.build(15, 1));
        expect(p1.isDuplicated, false);
        expect(p1.torrent!.id.id, equals(123));
        expect(p1.torrent!.id.hashStr, equals("hash_string_1"));
        expect(p1.torrent!.name, equals("torrent_name_1"));
      });
      test("override properties, duplicated", () {
        final p1 = TorrentAddResponseParam.fromJson(duplicateData,
            version: ServerRpcVersion.build(15, 1));
        expect(p1.isDuplicated, true);
        expect(p1.torrent!.id.id, equals(456));
        expect(p1.torrent!.id.hashStr, equals("hash_string_2"));
        expect(p1.torrent!.name, equals("torrent_name_2"));
        final p2 = TorrentAddResponseParam.fromJson(rawDataDuplicate,
            version: ServerRpcVersion.build(15, 1));
        expect(p2.isDuplicated, true);
        expect(p2.torrent!.id.id, equals(456));
        expect(p2.torrent!.id.hashStr, equals("hash_string_2"));
        expect(p2.torrent!.name, equals("torrent_name_2"));
      });
    });

void main() {
  testTorrentAddRequestArgs();
  testTorrentAddRequestParam();
  testTorrentAddRequestParamImpl();
  testTorrentAddRequestParamRpc17Impl();
  testTorrentAdded();
  testTorrentAddResponseParam();
  testTorrentAddResponseParamImpl();
  testTorrentAddResponseParamRpc15Impl();
}
