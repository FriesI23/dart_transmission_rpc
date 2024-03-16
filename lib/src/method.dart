// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

enum TransmissionRpcMethod {
  torrentStart(methodName: "torrent-start"),
  torrentStartNow(methodName: "torrent-start-now"),
  torrentStop(methodName: "torrent-stop"),
  torrentVerify(methodName: "torrent-verify"),
  torrentReannounce(methodName: "torrent-reannounce"),
  torrentGet(methodName: "torrent-get"),
  torrentSet(methodName: "torrent-set"),
  sessionSet(methodName: "session-set"),
  sessionGet(methodName: "session-get"),
  sessionStats(methodName: "session-stats"),
  blocklistUpdate(methodName: "blocklist-update"),
  portTest(methodName: "port-test"),
  queueMoveTop(methodName: "queue-move-top"),
  queueMoveUp(methodName: "queue-move-up"),
  queueMoveDown(methodName: "queue-move-down"),
  queueMoveBottom(methodName: "queue-move-bottom"),
  freeSpace(methodName: "free-space"),
  groupGet(methodName: "group-get"),
  groupSet(methodName: "group-set");

  final String methodName;

  const TransmissionRpcMethod({required this.methodName});
}
