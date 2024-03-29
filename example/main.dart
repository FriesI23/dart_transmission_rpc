// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import "dart:io" as io;

import 'package:dart_transmission_rpc/client.dart';
import 'package:dart_transmission_rpc/extensions.dart';
import 'package:dart_transmission_rpc/logging.dart';
import 'package:dart_transmission_rpc/model.dart';
import 'package:dart_transmission_rpc/src/utils.dart';

Future<void> testSessionGet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  client.init();
  client.init();
  await client.init();
  final result = await client.sessionGet(null, timeout: 5000);
  print(result.param?.version);
}

Future<void> testSessionSet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result1 = await client.sessionGet([SessionGetArgument.utpEnabled]);
  print("before: ${result1.param?.utpEnabled}");
  final result =
      await client.sessionSet(const SessionSetRequestArgs(utpEnabled: true));
  print("output: ${result.result}");
  final result2 = await client.sessionGet([SessionGetArgument.utpEnabled]);
  print("after: ${result2.param?.utpEnabled}");
}

Future<void> testSessionStats() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.sessionStats();
  print(result.param);
}

Future<void> testBlocklistUpdate() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.blocklistUpdate();
  print(result.result);
  print(result.param);
  print(result.isOk());
}

Future<void> testPortTest() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.portTest();
  print(result.result);
  print(result.param?.portIsOpen);
}

Future<void> testQueueMove() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result1 = await client.queueMoveUp(TorrentIds.recently());
  print(result1.result);
  print(result1.request.method);
  final result2 = await client.queueMoveTop(TorrentIds.recently());
  print(result2.result);
  print(result2.request.method);
  final result3 = await client.queueMoveDown(TorrentIds.recently());
  print(result3.result);
  print(result3.request.method);
  final result4 = await client.queueMoveBottom(TorrentIds.recently());
  print(result4.result);
  print(result4.request.method);
}

Future<void> testFreeSpace() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.freeSpace("/config");
  print(result.result);
  print(result.param?.path);
  print(result.param?.sizeBytes);
  print(result.param?.totalSize);
}

Future<void> testGroupGet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result1 = await client.groupGet(null);
  print(result1.result);
  print(result1.param?.group);
  final result2 = await client.groupGet(["test2"]);
  print(result2.result);
  print(result2.param?.group);
}

Future<void> testGroupSet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.groupSet(const GroupSetRequestArgs(
      name: "test2",
      speedLimitDownEnabled: true,
      speedLimitDown: 1000,
      speedLimitUp: 2000));
  print(result.result);
  print(result.param);
  final result2 = await client.groupGet(["test2"]);
  print(result2.result);
  for (var p in result2.param?.group ?? <GroupDesc>[]) {
    if (p.name == 'test2') {
      print(p.name);
      print(p.honorsSessionLimits);
      print(p.speedLimitDownEnabled);
      print(p.speedLimitDown);
      print(p.speedLimitUpEnabled);
      print(p.speedLimitUp);
    }
  }
}

Future<void> testTorrentStop({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result = await client.torrentStop(const TorrentIds([TorrentId(id: 2)]));
  print(result.result);
}

Future<void> testTorrentSart({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result =
      await client.torrentStart(const TorrentIds([TorrentId(id: 2)]));
  print(result.result);
}

Future<void> testTorrentSartNow({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result =
      await client.torrentStartNow(const TorrentIds([TorrentId(id: 2)]));
  print(result.result);
}

Future<void> testTorrentVerify({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result =
      await client.torrentVerify(const TorrentIds([TorrentId(id: 2)]));
  print(result.result);
}

Future<void> testTorrentReannounce({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result =
      await client.torrentReannounce(const TorrentIds([TorrentId(id: 2)]));
  print(result.result);
}

Future<void> testTorrentGet({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result = await client.torrentGet([
    TorrentGetArgument.name,
    TorrentGetArgument.id,
    TorrentGetArgument.hashString,
    TorrentGetArgument.addedDate,
    TorrentGetArgument.pieces,
    // rpc18
    TorrentGetArgument.sequentialDownload,
    // rpc17
    TorrentGetArgument.availability,
    TorrentGetArgument.fileCount,
    TorrentGetArgument.group,
    TorrentGetArgument.percentComplete,
    TorrentGetArgument.primaryMimeType,
    TorrentGetArgument.trackerList,
    // rpc16
    TorrentGetArgument.labels,
    TorrentGetArgument.editDate,
  ]);
  print(result.result);
  print('------ torrents -----------');
  for (var p in result.param!.torrents) {
    print(p.name);
    print(p.id);
    print(p.addedDate);
    print(p.trackerList);
  }
  print('--------- removed ---------');
  for (var p in result.param!.removed) {
    print(p.hashStr);
    print(p.id);
  }
}

Future<void> testTorrentGetAll({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result =
      await client.torrentGetAll(const TorrentIds([TorrentId(id: 1)]));
  print(result.result);
  print('------ torrents -----------');
  for (var p in result.param!.torrents) {
    print(p.name);
    print(p.id);
    print(p.addedDate);
  }
  print('--------- removed ---------');
  for (var p in result.param!.removed) {
    print(p.hashStr);
    print(p.id);
  }
}

Future<void> testTorrentSet({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final r1 = await client.torrentGetAll(const TorrentIds.empty());
  print(r1.param!.torrents[0].id);
  print(r1.param!.torrents[0].name);
  print(r1.param!.torrents[0].labels);
  print(r1.param!.torrents[0].seedIdleMode);
  print(r1.param!.torrents[0].seedRatioMode);
  final r2 = await client.torrentSet(const TorrentSetRequestArgs(
    // ids: TorrentIds.torrentSetForAll(),
    // ids: TorrentIds([TorrentId(id: 2)]),
    ids: TorrentIds.empty(),
    labels: ["test", "foo", "bar", "new"],
    seedIdleMode: IdleLimitMode.single,
    seedRatioMode: RatioLimitMode.unlimited,
  ));
  print(r2.result);
  final r3 = await client.torrentGetAll(const TorrentIds.empty());
  print(r3.param!.torrents[0].labels);
  print(r3.param!.torrents[0].seedIdleMode);
  print(r3.param!.torrents[0].seedRatioMode);
}

Future<void> testTorrentRemove({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final r1 = await client.torrentGetAll(const TorrentIds.empty());
  final r1id = r1.param!.torrents[0].id;
  final result = await client.torrentRemove(TorrentIds([r1id!]));
  print(result.result);
  print(result.param);
}

Future<void> testTorrentAdd({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result = await client.torrentAdd(
    TorrentAddRequestArgs(
      fileInfo: TorrentAddFileInfo.byMetainfo(
          io.File("demo/demo_test.torrent").readAsBytesSync()),
      downloadDir: "/downloads/complete",
      labels: ["test", "test1"],
    ),
  );
  print('1----------------------');
  print(result.result);
  print(result.param?.isDuplicated);
  print(result.param?.torrent?.id);
  print(result.param?.torrent?.name);
  print(result.param.runtimeType);

  final result2 = await client.torrentAdd(
    TorrentAddRequestArgs(
      fileInfo: TorrentAddFileInfo.byFilename(
          "magnet:?xt=urn:btih:cce82738e2f9217c5631549b0b8c1dfe12331503&dn=debian-12.5.0-i386-netinst.iso"),
      downloadDir: "/downloads/complete",
      labels: ["test", "test1", "test2"],
    ),
  );
  print('2----------------------');
  print(result2.result);
  print(result2.param?.isDuplicated);
  print(result2.param?.torrent?.id);
  print(result2.param?.torrent?.name);
  print(result2.param.runtimeType);
}

Future<void> testTorrentSetLocation({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result1 = await client.torrentAdd(
    TorrentAddRequestArgs(
      fileInfo: TorrentAddFileInfo.byMetainfo(
          io.File("demo/demo_test.torrent").readAsBytesSync()),
      downloadDir: "/downloads/complete",
    ),
  );
  final ids =
      TorrentIds([TorrentId(id: result1.param!.torrent!.id.id!.toInt())]);
  await client.torrentSetLocation(
      TorrentSetLocationArgs(ids: ids, location: "/downloads"));
  final result2 = await client.torrentGet([
    TorrentGetArgument.id,
    TorrentGetArgument.name,
    TorrentGetArgument.downloadDir,
  ], ids: ids);
  print(result2.param?.torrents.firstOrNull?.id);
  print(result2.param?.torrents.firstOrNull?.name);
  print(result2.param?.torrents.firstOrNull?.downloadDir);
}

Future<void> testTorrentRenamePath({TransmissionRpcClient? c}) async {
  final client =
      c ?? TransmissionRpcClient(username: "admin", password: "123456");
  if (c == null) await client.init();
  final result1 = await client.torrentAdd(
    TorrentAddRequestArgs(
      fileInfo: TorrentAddFileInfo.byMetainfo(
          io.File("demo/demo_test.torrent").readAsBytesSync()),
      downloadDir: "/downloads/complete",
    ),
  );
  final ids =
      TorrentIds([TorrentId(id: result1.param!.torrent!.id.id!.toInt())]);
  final result2 = await client.torrentGet(
      [TorrentGetArgument.files, TorrentGetArgument.fileStats],
      ids: ids);
  print(result2.param?.torrents.first.files?.first);
  print(result2.param?.torrents.first.fileStats?.first);
  final result3 = await client.torrentRenamePath(TorrentRenamePathArgs(
      id: ids.first,
      oldPath: "debian-12.5.0-i386-netinst.iso",
      newName: "debian-12.5.0-i386-netinst.rename.iso"));
  print(result3.result);
  print(result3.param?.id);
  print(result3.param?.path);
  print(result3.param?.name);
  final result4 = await client.torrentGet(
      [TorrentGetArgument.files, TorrentGetArgument.fileStats],
      ids: ids);
  print(result4.param?.torrents.first.files?.first);
  print(result4.param?.torrents.first.fileStats?.first);
}

Future<void> testSessionClose() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.sessionClose();
  print(result.result);
}

void main() async {
  Logger("TransmissionRpcClient", showLevel: LogLevel.debug);
  await testSessionGet();
  // await testSessionSet();
  // await testSessionStats();
  // await testBlocklistUpdate();
  // await testPortTest();
  // await testQueueMove();
  // await testFreeSpace();
  // await testGroupGet();
  // await testGroupSet();
  // await testSessionClose();

  // await testTorrentStop();
  // await testTorrentSart();
  // await testTorrentSartNow();
  // await testTorrentVerify();
  // await testTorrentReannounce();
  // await testTorrentGet();
  // await testTorrentGetAll();
  // await testTorrentSet();
  // await testTorrentRemove();
  // await testTorrentAdd();
  // await testTorrentSetLocation();
  // await testTorrentRenamePath();
}
