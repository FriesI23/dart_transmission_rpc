// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

enum TransmissionRpcMethod {
  sessionSet(methodName: "session-set"),
  sessionGet(methodName: "session-get"),
  sessionStats(methodName: "session-stats"),
  blocklistUpdate(methodName: "blocklist-update"),
  portTest(methodName: "port-test");

  final String methodName;

  const TransmissionRpcMethod({required this.methodName});
}
