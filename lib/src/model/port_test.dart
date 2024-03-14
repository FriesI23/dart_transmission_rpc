// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';

enum PortTestArgument {
  portIsOpen(argName: "port-is-open");

  final String argName;

  const PortTestArgument({required this.argName});
}

// TODO: add ipProtocol support, which added after rpc-version 18.
class PortTestReqeustParam implements RequestParam {
  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {};
}

class PortTestResponseParam implements ResponseParam {
  final bool portIsOpen;

  const PortTestResponseParam({required this.portIsOpen});

  factory PortTestResponseParam.fromJson(JsonMap rawData) {
    return PortTestResponseParam(
        portIsOpen: rawData[PortTestArgument.portIsOpen.argName] as bool);
  }
}
