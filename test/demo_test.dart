// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_transmission_rpc/src/client.dart';

void testSessionGet() async {
  final client = TransmissionRpcClient(username: "admin", password: "123456");
  await client.init();
  final result = await client.sessionGet(null, timeout: 5000);
  print(result.param?.version);
}

void main() async {
  // testSessionGet();
}
