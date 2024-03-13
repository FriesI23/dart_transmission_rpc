// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

enum TransmissionRpcMethod {
  sessionSet(methodName: "session-set"),
  sessionGet(methodName: "session-get");

  final String methodName;

  const TransmissionRpcMethod({required this.methodName});
}
