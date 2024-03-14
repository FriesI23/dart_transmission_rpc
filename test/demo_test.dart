// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: avoid_print

import 'package:flutter_transmission_rpc/src/model/session_get.dart';
import 'package:flutter_transmission_rpc/src/model/session_set.dart';
import 'package:flutter_transmission_rpc/src/client.dart';
import 'package:flutter_transmission_rpc/src/model/torrent.dart';

void testSessionGet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.sessionGet(null, timeout: 5000);
  print(result.param?.version);
}

void testSessionSet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result1 = await client.sessionGet([SessionGetArgument.utpEnabled]);
  print("before: ${result1.param?.utpEnabled}");
  final result =
      await client.sessionSet(SessionSetRequestArgs(utpEnabled: true));
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

void main() async {
  // testSessionGet();
  // testSessionSet();
  // await testSessionStats();
  // await testBlocklistUpdate();
  // await testPortTest();
  // await testQueueMove();
  await testFreeSpace();
}
