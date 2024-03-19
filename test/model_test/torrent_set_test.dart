// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:dart_transmission_rpc/model.dart';
import 'package:dart_transmission_rpc/src/exception.dart';
import 'package:dart_transmission_rpc/src/typedef.dart';
import 'package:dart_transmission_rpc/src/utils.dart';
import 'package:test/test.dart';

TorrentSetRequestArgs buildTestingUseNoNullArgs({TorrentIds? ids}) =>
    TorrentSetRequestArgs(
      ids: ids ?? TorrentIds.empty(),
      bandwidthPriority: 2,
      downloadLimit: 100,
      downloadLimited: true,
      filesUnwanted: FileIndices.empty(),
      filesWanted: FileIndices.empty(),
      honorsSessionLimits: false,
      location: '/downloads',
      peerLimit: 50,
      priorityHigh: FileIndices.empty(),
      priorityLow: FileIndices.empty(),
      priorityNormal: FileIndices.empty(),
      queuePosition: 1,
      seedIdleLimit: 10,
      seedIdleMode: IdleLimitMode.global,
      seedRatioLimit: 2,
      seedRatioMode: RatioLimitMode.single,
      sequentialDownload: true,
      trackerAdd: ['http://tracker1.com', 'http://tracker2.com'],
      trackerRemove: [1, 2],
      trackerReplace: [
        TrackerReplace(id: 1, url: 'http://newtracker1.com'),
        TrackerReplace(id: 2, url: 'http://newtracker2.com')
      ],
      uploadLimit: 200,
      uploadLimited: false,
      labels: ['Label1', 'Label2'],
      group: 'Group1',
      trackerList: [
        ['http://trackerlist1.com', 'http://trackerlist2.com'],
        ['http://trackerlist3.com', 'http://trackerlist4.com'],
      ],
    );

TorrentSetRequestArgs buildTestingUseStructArgs({TorrentIds? ids}) =>
    TorrentSetRequestArgs(
      ids: ids ?? TorrentIds.empty(),
      bandwidthPriority: 2,
      downloadLimit: 100,
      downloadLimited: true,
      filesUnwanted: FileIndices([1, 2]),
      filesWanted: FileIndices.empty(),
      honorsSessionLimits: false,
      location: '/downloads',
      peerLimit: 50,
      priorityHigh: FileIndices([3, 4]),
      priorityLow: FileIndices.empty(),
      priorityNormal: FileIndices.empty(),
      queuePosition: 1,
      seedIdleLimit: 10,
      seedIdleMode: IdleLimitMode.single,
      seedRatioLimit: 2,
      seedRatioMode: RatioLimitMode.unlimited,
      trackerAdd: ['http://tracker1.com', 'http://tracker2.com'],
      trackerRemove: [1, 2],
      trackerReplace: [
        TrackerReplace(id: 1, url: 'http://newtracker1.com'),
        TrackerReplace(id: 2, url: 'http://newtracker2.com')
      ],
      uploadLimit: 200,
      uploadLimited: false,
      labels: ['Label1', 'Label2'],
      group: 'Group1',
      trackerList: [
        ['http://trackerlist1.com', 'http://trackerlist2.com'],
        ['http://trackerlist3.com', 'http://trackerlist4.com'],
      ],
      sequentialDownload: true,
    );

JsonMap buildTestingUseStructExpectJson({List<int>? expectIds, num? v}) => {
      'ids': expectIds,
      'bandwidthPriority': 2,
      'downloadLimit': 100,
      'downloadLimited': true,
      'files-unwanted': [1, 2],
      'files-wanted': [],
      'honorsSessionLimits': false,
      'location': '/downloads',
      'peer-limit': 50,
      'priority-high': [3, 4],
      'priority-low': [],
      'priority-normal': [],
      'queuePosition': 1,
      'seedIdleLimit': 10,
      'seedIdleMode': 1,
      'seedRatioLimit': 2,
      'seedRatioMode': 2,
      'trackerAdd': ['http://tracker1.com', 'http://tracker2.com'],
      'trackerRemove': [1, 2],
      'trackerReplace': [
        [1, 'http://newtracker1.com'],
        [2, 'http://newtracker2.com']
      ],
      'uploadLimit': 200,
      'uploadLimited': false,
      if (v != null && v >= 16) "labels": ["Label1", "Label2"],
      if (v != null && v >= 17) ...{
        'group': 'Group1',
        'trackerList': 'http://trackerlist1.com\n'
            '\n'
            'http://trackerlist2.com\n'
            'http://trackerlist3.com\n'
            '\n'
            'http://trackerlist4.com'
      },
      if (v != null && v >= 18) "sequentialDownload": true,
    };

class TorrentSetRequestParamStub extends TorrentSetRequestParam {
  final JsonMap Function()? _toRpcJson;

  TorrentSetRequestParamStub({
    required super.args,
    this.allowedFields = const {},
    this.deprecatedFields = const {},
    JsonMap Function()? toRpcJson,
  }) : _toRpcJson = toRpcJson;

  @override
  final Set<TorrentSetArgument> allowedFields;

  @override
  final Set<TorrentSetArgument> deprecatedFields;

  @override
  JsonMap toRpcJson() => _toRpcJson?.call() ?? {};
}

void testTrackerReplace() => group("test TrackerReplace", () {
      test("constructor: ()", () {
        final trackerReplace = TrackerReplace(id: 1, url: "test");
        expect(trackerReplace.id, 1);
        expect(trackerReplace.url, "test");
      });
      test("operator: ==", () {
        final t1 = TrackerReplace(id: 1, url: "test");
        final t2 = TrackerReplace(id: 1, url: "test");
        final t3 = TrackerReplace(id: 1, url: "test2");
        final t4 = TrackerReplace(id: 2, url: "test");
        final t5 = TrackerReplace(id: 2, url: "test2");
        expect(t1 == t2, true);
        expect(t1.hashCode == t2.hashCode, true);
        expect(t1 != t3, true);
        expect(t1.hashCode == t3.hashCode, false);
        expect(t1 != t4, true);
        expect(t1.hashCode == t4.hashCode, false);
        expect(t1 != t5, true);
        expect(t1.hashCode == t5.hashCode, false);
      });
    });

void testTorrentSetRequestArgs() => group("test TorrentSetRequestArgs", () {
      group("constructor: ()", () {
        test("with args", () {
          final args = TorrentSetRequestArgs(
            ids: TorrentIds.empty(),
            bandwidthPriority: 2,
            downloadLimit: 100,
            downloadLimited: true,
            filesUnwanted: FileIndices.empty(),
            filesWanted: FileIndices.empty(),
            honorsSessionLimits: false,
            location: '/downloads',
            peerLimit: 50,
            priorityHigh: FileIndices.empty(),
            priorityLow: FileIndices.empty(),
            priorityNormal: FileIndices.empty(),
            queuePosition: 1,
            seedIdleLimit: 10,
            seedIdleMode: IdleLimitMode.global,
            seedRatioLimit: 2,
            seedRatioMode: RatioLimitMode.single,
            sequentialDownload: true,
            trackerAdd: ['http://tracker1.com', 'http://tracker2.com'],
            trackerRemove: [1, 2],
            trackerReplace: [
              TrackerReplace(id: 1, url: 'http://newtracker1.com'),
              TrackerReplace(id: 2, url: 'http://newtracker2.com')
            ],
            uploadLimit: 200,
            uploadLimited: false,
            labels: ['Label1', 'Label2'],
            group: 'Group1',
            trackerList: [
              ['http://trackerlist1.com', 'http://trackerlist2.com'],
              ['http://trackerlist3.com', 'http://trackerlist4.com'],
            ],
          );

          expect(args.getValueByArgument(TorrentSetArgument.ids),
              equals(TorrentIds.empty()));
          expect(args.getValueByArgument(TorrentSetArgument.bandwidthPriority),
              equals(2));
          expect(args.getValueByArgument(TorrentSetArgument.downloadLimit),
              equals(100));
          expect(args.getValueByArgument(TorrentSetArgument.downloadLimited),
              equals(true));
          expect(args.getValueByArgument(TorrentSetArgument.filesUnwanted),
              equals(FileIndices.empty()));
          expect(args.getValueByArgument(TorrentSetArgument.filesWanted),
              equals(FileIndices.empty()));
          expect(
              args.getValueByArgument(TorrentSetArgument.honorsSessionLimits),
              equals(false));
          expect(args.getValueByArgument(TorrentSetArgument.location),
              equals('/downloads'));
          expect(args.getValueByArgument(TorrentSetArgument.peerLimit),
              equals(50));
          expect(args.getValueByArgument(TorrentSetArgument.priorityHigh),
              equals(FileIndices.empty()));
          expect(args.getValueByArgument(TorrentSetArgument.priorityLow),
              equals(FileIndices.empty()));
          expect(args.getValueByArgument(TorrentSetArgument.priorityNormal),
              equals(FileIndices.empty()));
          expect(args.getValueByArgument(TorrentSetArgument.queuePosition),
              equals(1));
          expect(args.getValueByArgument(TorrentSetArgument.seedIdleLimit),
              equals(10));
          expect(args.getValueByArgument(TorrentSetArgument.seedIdleMode),
              equals(IdleLimitMode.global));
          expect(args.getValueByArgument(TorrentSetArgument.seedRatioLimit),
              equals(2));
          expect(args.getValueByArgument(TorrentSetArgument.seedRatioMode),
              equals(RatioLimitMode.single));
          expect(args.getValueByArgument(TorrentSetArgument.sequentialDownload),
              equals(true));
          expect(args.getValueByArgument(TorrentSetArgument.trackerAdd),
              equals(['http://tracker1.com', 'http://tracker2.com']));
          expect(args.getValueByArgument(TorrentSetArgument.trackerRemove),
              equals([1, 2]));
          expect(
              args.getValueByArgument(TorrentSetArgument.trackerReplace),
              equals([
                TrackerReplace(id: 1, url: 'http://newtracker1.com'),
                TrackerReplace(id: 2, url: 'http://newtracker2.com')
              ]));
          expect(args.getValueByArgument(TorrentSetArgument.uploadLimit),
              equals(200));
          expect(args.getValueByArgument(TorrentSetArgument.uploadLimited),
              equals(false));
          expect(args.getValueByArgument(TorrentSetArgument.labels),
              equals(['Label1', 'Label2']));
          expect(args.getValueByArgument(TorrentSetArgument.group),
              equals('Group1'));
          expect(
              args.getValueByArgument(TorrentSetArgument.trackerList),
              equals([
                ['http://trackerlist1.com', 'http://trackerlist2.com'],
                ['http://trackerlist3.com', 'http://trackerlist4.com'],
              ]));
        });
        test('Get value by argument with empty arguments', () {
          final args = TorrentSetRequestArgs(ids: TorrentIds.empty());

          expect(args.getValueByArgument(TorrentSetArgument.bandwidthPriority),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.downloadLimit),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.downloadLimited),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.filesUnwanted),
              isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.filesWanted), isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.honorsSessionLimits),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.location), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.peerLimit), isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.priorityHigh), isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.priorityLow), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.priorityNormal),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.queuePosition),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.seedIdleLimit),
              isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.seedIdleMode), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.seedRatioLimit),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.seedRatioMode),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.sequentialDownload),
              isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.trackerAdd), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.trackerRemove),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.trackerReplace),
              isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.uploadLimit), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.uploadLimited),
              isNull);
          expect(args.getValueByArgument(TorrentSetArgument.labels), isNull);
          expect(args.getValueByArgument(TorrentSetArgument.group), isNull);
          expect(
              args.getValueByArgument(TorrentSetArgument.trackerList), isNull);
        });
      });
      test("method: getValueByArgument", () {
        final args = TorrentSetRequestArgs(
          ids: TorrentIds.empty(),
          bandwidthPriority: 2,
          downloadLimit: 100,
          downloadLimited: true,
          filesUnwanted: FileIndices.empty(),
          filesWanted: FileIndices.empty(),
          honorsSessionLimits: false,
          location: '/downloads',
          peerLimit: 50,
          priorityHigh: FileIndices.empty(),
          priorityLow: FileIndices.empty(),
          priorityNormal: FileIndices.empty(),
          queuePosition: 1,
          seedIdleLimit: 10,
          seedIdleMode: IdleLimitMode.global,
          seedRatioLimit: 2,
          seedRatioMode: RatioLimitMode.single,
          sequentialDownload: true,
          trackerAdd: ['http://tracker1.com', 'http://tracker2.com'],
          trackerRemove: [1, 2],
          trackerReplace: [
            TrackerReplace(id: 1, url: 'http://newtracker1.com'),
            TrackerReplace(id: 2, url: 'http://newtracker2.com')
          ],
          uploadLimit: 200,
          uploadLimited: false,
          labels: ['Label1', 'Label2'],
          group: 'Group1',
          trackerList: [
            ['http://trackerlist1.com', 'http://trackerlist2.com'],
            ['http://trackerlist3.com', 'http://trackerlist4.com'],
          ],
        );

        expect(
            args.getValueByArgument(TorrentSetArgument.ids), equals(args.ids));
        expect(args.getValueByArgument(TorrentSetArgument.bandwidthPriority),
            equals(args.bandwidthPriority));
        expect(args.getValueByArgument(TorrentSetArgument.downloadLimit),
            equals(args.downloadLimit));
        expect(args.getValueByArgument(TorrentSetArgument.downloadLimited),
            equals(args.downloadLimited));
        expect(args.getValueByArgument(TorrentSetArgument.filesUnwanted),
            equals(args.filesUnwanted));
        expect(args.getValueByArgument(TorrentSetArgument.filesWanted),
            equals(args.filesWanted));
        expect(args.getValueByArgument(TorrentSetArgument.honorsSessionLimits),
            equals(args.honorsSessionLimits));
        expect(args.getValueByArgument(TorrentSetArgument.location),
            equals(args.location));
        expect(args.getValueByArgument(TorrentSetArgument.peerLimit),
            equals(args.peerLimit));
        expect(args.getValueByArgument(TorrentSetArgument.priorityHigh),
            equals(args.priorityHigh));
        expect(args.getValueByArgument(TorrentSetArgument.priorityLow),
            equals(args.priorityLow));
        expect(args.getValueByArgument(TorrentSetArgument.priorityNormal),
            equals(args.priorityNormal));
        expect(args.getValueByArgument(TorrentSetArgument.queuePosition),
            equals(args.queuePosition));
        expect(args.getValueByArgument(TorrentSetArgument.seedIdleLimit),
            equals(args.seedIdleLimit));
        expect(args.getValueByArgument(TorrentSetArgument.seedIdleMode),
            equals(args.seedIdleMode));
        expect(args.getValueByArgument(TorrentSetArgument.seedRatioLimit),
            equals(args.seedRatioLimit));
        expect(args.getValueByArgument(TorrentSetArgument.seedRatioMode),
            equals(args.seedRatioMode));
        expect(args.getValueByArgument(TorrentSetArgument.sequentialDownload),
            equals(args.sequentialDownload));
        expect(args.getValueByArgument(TorrentSetArgument.trackerAdd),
            equals(args.trackerAdd));
        expect(args.getValueByArgument(TorrentSetArgument.trackerRemove),
            equals(args.trackerRemove));
        expect(args.getValueByArgument(TorrentSetArgument.trackerReplace),
            equals(args.trackerReplace));
        expect(args.getValueByArgument(TorrentSetArgument.uploadLimit),
            equals(args.uploadLimit));
        expect(args.getValueByArgument(TorrentSetArgument.uploadLimited),
            equals(args.uploadLimited));
        expect(args.getValueByArgument(TorrentSetArgument.labels),
            equals(args.labels));
        expect(args.getValueByArgument(TorrentSetArgument.group),
            equals(args.group));
        expect(args.getValueByArgument(TorrentSetArgument.trackerList),
            equals(args.trackerList));
      });
    });

void testTorrentSetRequestParam() => group("test TorrentSetRequestParam", () {
      TorrentSetRequestArgs? requestArgs;
      setUp(() {
        requestArgs = buildTestingUseNoNullArgs();
      });
      group("facotry constructor: build", () {
        test("no version", () {
          final p = TorrentSetRequestParam.build(args: requestArgs!);
          expect(p.runtimeType.toString(), "_TorrentSetRequestParam");
        });
        test("highest rpc", () {
          final p = TorrentSetRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(99, 1));
          expect(p.runtimeType.toString(), "_TorrentSetRequestParamRpc18");
        });
        test("rpc18", () {
          final p = TorrentSetRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(18, 1));
          expect(p.runtimeType.toString(), "_TorrentSetRequestParamRpc18");
        });
        test("rpc17", () {
          final p = TorrentSetRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(17, 1));
          expect(p.runtimeType.toString(), "_TorrentSetRequestParamRpc17");
        });
        test("rpc16", () {
          final p = TorrentSetRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(16, 1));
          expect(p.runtimeType.toString(), "_TorrentSetRequestParamRpc16");
        });
        test("default", () {
          final p = TorrentSetRequestParam.build(
              args: requestArgs!, version: ServerRpcVersion.build(15, 1));
          expect(p.runtimeType.toString(), "_TorrentSetRequestParam");
        });
        test("no version", () {
          expect(
              () => TorrentSetRequestParam.build(
                  args: requestArgs!,
                  version:
                      ServerRpcVersion.build(kMinimumSupportRpcVersion - 1, 1)),
              throwsA(TypeMatcher<TransmissionVersionError>()));
        });
      });
      test("override properties getter", () {
        final args = requestArgs!;
        final requestParam = TorrentSetRequestParamStub(args: args);

        expect(requestParam.ids, args.ids);
        expect(requestParam.bandwidthPriority, args.bandwidthPriority);
        expect(requestParam.downloadLimit, args.downloadLimit);
        expect(requestParam.downloadLimited, args.downloadLimited);
        expect(requestParam.filesUnwanted, args.filesUnwanted);
        expect(requestParam.filesWanted, args.filesWanted);
        expect(requestParam.honorsSessionLimits, args.honorsSessionLimits);
        expect(requestParam.location, args.location);
        expect(requestParam.peerLimit, args.peerLimit);
        expect(requestParam.priorityHigh, args.priorityHigh);
        expect(requestParam.priorityLow, args.priorityLow);
        expect(requestParam.priorityNormal, args.priorityNormal);
        expect(requestParam.queuePosition, args.queuePosition);
        expect(requestParam.seedIdleLimit, args.seedIdleLimit);
        expect(requestParam.seedIdleMode, args.seedIdleMode);
        expect(requestParam.seedRatioLimit, args.seedRatioLimit);
        expect(requestParam.seedRatioMode, args.seedRatioMode);
        expect(requestParam.trackerAdd, args.trackerAdd);
        expect(requestParam.trackerRemove, args.trackerRemove);
        expect(requestParam.trackerReplace, args.trackerReplace);
        expect(requestParam.uploadLimit, args.uploadLimit);
        expect(requestParam.uploadLimited, args.uploadLimited);
        expect(requestParam.labels, args.labels);
        expect(requestParam.group, args.group);
        expect(requestParam.trackerList, args.trackerList);
        expect(requestParam.sequentialDownload, args.sequentialDownload);
      });
      group("method: check", () {
        test("all passed", () {
          final p = TorrentSetRequestParamStub(
              args: requestArgs!,
              allowedFields: TorrentSetArgument.allFieldsSet);
          final r = p.check();
          expect(r, null);
        });
        test("some fields not allowed", () {
          final p = TorrentSetRequestParamStub(args: requestArgs!);
          final r = p.check();
          expect(r, contains("prohibited"));
          expect(r!.contains("deprecated"), false);
        });

        test("some fields deprecated", () {
          final p = TorrentSetRequestParamStub(
              args: requestArgs!,
              allowedFields: TorrentSetArgument.allFieldsSet,
              deprecatedFields: TorrentSetArgument.allFieldsSet);
          final r = p.check();
          expect(r!.contains("prohibited"), false);
          expect(r, contains("deprecated"));
        });
        test("both fields deprecated and not allowed", () {
          final p = TorrentSetRequestParamStub(
              args: requestArgs!,
              allowedFields: {TorrentSetArgument.bandwidthPriority},
              deprecatedFields: {TorrentSetArgument.filesWanted});
          final r = p.check();
          expect(r, contains("prohibited"));
          expect(r, contains("deprecated"));
        });
      });
    });

void testTorrentSetRequestParamImpl() =>
    group("test _TorrentSetRequestParam", () {
      final args = buildTestingUseNoNullArgs();
      TorrentSetRequestParam? p;
      setUp(() {
        p = TorrentSetRequestParam.build(args: args);
      });
      test("allowedFields", () {
        expect(
            p!.allowedFields,
            equals({
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
            }));
      });
      test("check", () {
        final p1 = TorrentSetRequestParam.build(
            args: TorrentSetRequestArgs(ids: TorrentIds.empty()));
        expect(p1.check(), isNull);
        final p2 = TorrentSetRequestParam.build(
            args: TorrentSetRequestArgs(
                ids: TorrentIds.empty(), downloadLimit: 1));
        expect(p2.check(), isNull);
        final p3 = TorrentSetRequestParam.build(
            args: TorrentSetRequestArgs(
                ids: TorrentIds.empty(), group: "something"));
        expect(p3.check(), contains("prohibited"));
      });
      group("toJson", () {
        test("struct", () {
          final p = TorrentSetRequestParam.build(
            args: buildTestingUseStructArgs(
              ids: TorrentIds([TorrentId(id: 123)]),
            ),
          );
          expect(
              p.toRpcJson(), buildTestingUseStructExpectJson(expectIds: [123]));
        });
        test("default", () {
          final p1 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.empty()));
          expect(p1.toRpcJson(), {});
          final p2 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.recently()));
          expect(p2.toRpcJson(), {"ids": "recently-active"});
        });
        test("with args", () {
          var r = p!.toRpcJson();
          for (var f in p!.allowedFields) {
            if (f == TorrentSetArgument.ids) continue;
            expect(r[f.argName], isNotNull, reason: "check field failed: $f");
            r.remove(f.argName);
          }
          expect(r.isEmpty, true, reason: "extra key: $r");
        });
      });
    });

void testTorrentSetRequestParamRpc16Impl() =>
    group("test _TorrentSetRequestParamRpc16", () {
      final args = buildTestingUseNoNullArgs();
      TorrentSetRequestParam? p;
      setUp(() {
        p = TorrentSetRequestParam.build(
            args: args, version: ServerRpcVersion.build(16, 1));
      });
      test("allowedFields", () {
        expect(
            p!.allowedFields,
            equals({
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
              TorrentSetArgument.labels, // rpc16
            }));
      });
      group("toJson", () {
        test("struct", () {
          final p = TorrentSetRequestParam.build(
            args: buildTestingUseStructArgs(
              ids: TorrentIds([TorrentId(id: 123)]),
            ),
            version: ServerRpcVersion.build(16, 1),
          );
          expect(p.toRpcJson(),
              buildTestingUseStructExpectJson(expectIds: [123], v: 16));
        });
        test("default", () {
          final p1 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.empty()));
          expect(p1.toRpcJson(), {});
          final p2 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.recently()));
          expect(p2.toRpcJson(), {"ids": "recently-active"});
        });
        test("with args", () {
          var r = p!.toRpcJson();
          for (var f in p!.allowedFields) {
            if (f == TorrentSetArgument.ids) continue;
            expect(r[f.argName], isNotNull, reason: "check field failed: $f");
            r.remove(f.argName);
          }
          expect(r.isEmpty, true, reason: "extra key: $r");
        });
      });
    });

void testTorrentSetRequestParamRpc17Impl() =>
    group("test _TorrentSetRequestParamRpc17", () {
      final args = buildTestingUseNoNullArgs();
      TorrentSetRequestParam? p;
      setUp(() {
        p = TorrentSetRequestParam.build(
            args: args, version: ServerRpcVersion.build(17, 1));
      });
      test("allowedFields", () {
        expect(
            p!.allowedFields,
            equals({
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
              TorrentSetArgument.labels, // rpc16
              TorrentSetArgument.group, // rpc17
              TorrentSetArgument.trackerList, // rpc17
            }));
      });
      test("deprecatedFields", () {
        expect(p!.deprecatedFields, {
          TorrentSetArgument.trackerAdd, // rpc17
          TorrentSetArgument.trackerRemove, // rpc17
          TorrentSetArgument.trackerReplace, // rpc17
        });
      });
      group("toJson", () {
        test("struct", () {
          final p = TorrentSetRequestParam.build(
            args: buildTestingUseStructArgs(
              ids: TorrentIds([TorrentId(id: 123)]),
            ),
            version: ServerRpcVersion.build(17, 1),
          );
          expect(p.toRpcJson(),
              buildTestingUseStructExpectJson(expectIds: [123], v: 17));
        });
        test("default", () {
          final p1 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.empty()));
          expect(p1.toRpcJson(), {});
          final p2 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.recently()));
          expect(p2.toRpcJson(), {"ids": "recently-active"});
        });
        test("with args", () {
          var r = p!.toRpcJson();
          for (var f in p!.allowedFields) {
            if (f == TorrentSetArgument.ids) continue;
            expect(r[f.argName], isNotNull, reason: "check field failed: $f");
            // print("$f, ${r[f.argName]}");
            r.remove(f.argName);
          }
          expect(r.isEmpty, true, reason: "extra key: $r");
        });
      });
    });

void testTorrentSetRequestParamRpc18Impl() =>
    group("test _TorrentSetRequestParamRpc17", () {
      final args = buildTestingUseNoNullArgs();
      TorrentSetRequestParam? p;
      setUp(() {
        p = TorrentSetRequestParam.build(
            args: args, version: ServerRpcVersion.build(18, 1));
      });
      test("allowedFields", () {
        expect(
            p!.allowedFields,
            equals({
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
              TorrentSetArgument.labels, // rpc16
              TorrentSetArgument.group, // rpc17
              TorrentSetArgument.trackerList, // rpc17
              TorrentSetArgument.sequentialDownload, // rpc18
            }));
      });
      test("deprecatedFields", () {
        expect(p!.deprecatedFields, {
          TorrentSetArgument.trackerAdd, // rpc17
          TorrentSetArgument.trackerRemove, // rpc17
          TorrentSetArgument.trackerReplace, // rpc17
        });
      });
      group("toJson", () {
        test("struct", () {
          final p = TorrentSetRequestParam.build(
            args: buildTestingUseStructArgs(
              ids: TorrentIds([TorrentId(id: 123)]),
            ),
            version: ServerRpcVersion.build(18, 1),
          );
          expect(p.toRpcJson(),
              buildTestingUseStructExpectJson(expectIds: [123], v: 18));
        });
        test("default", () {
          final p1 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.empty()));
          expect(p1.toRpcJson(), {});
          final p2 = TorrentSetRequestParam.build(
              args: TorrentSetRequestArgs(ids: TorrentIds.recently()));
          expect(p2.toRpcJson(), {"ids": "recently-active"});
        });
        test("with args", () {
          var r = p!.toRpcJson();
          for (var f in p!.allowedFields) {
            if (f == TorrentSetArgument.ids) continue;
            expect(r[f.argName], isNotNull, reason: "check field failed: $f");
            // print("$f, ${r[f.argName]}");
            r.remove(f.argName);
          }
          expect(r.isEmpty, true, reason: "extra key: $r");
        });
      });
    });

void testTorrentSetResponseParam() => group("test TorrentSetResponseParam", () {
      test("constructor: ()", () {
        final p = TorrentSetResponseParam();
        expect(p.runtimeType.toString(), "TorrentSetResponseParam");
      });
      test("factory constructor: fromJson", () {
        final p = TorrentSetResponseParam.fromJson({});
        expect(p.runtimeType.toString(), "TorrentSetResponseParam");
      });
    });

void main() {
  testTrackerReplace();
  testTorrentSetRequestArgs();
  testTorrentSetRequestParam();
  testTorrentSetRequestParamImpl();
  testTorrentSetRequestParamRpc16Impl();
  testTorrentSetRequestParamRpc17Impl();
  testTorrentSetRequestParamRpc18Impl();
  testTorrentSetResponseParam();
}
