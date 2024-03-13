// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';

enum BlocklistUpdateArguments {
  blocklistSize(argName: "blocklist-size");

  final String argName;

  const BlocklistUpdateArguments({required this.argName});
}

class BlocklistUpdateRequestParam implements RequestParam {
  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {};
}

class BlocklistUpdateResponseParam implements ResponseParam {
  final num blocklistSize;

  const BlocklistUpdateResponseParam({required this.blocklistSize});

  factory BlocklistUpdateResponseParam.fromJson(JsonMap rawData) {
    return BlocklistUpdateResponseParam(
      blocklistSize:
          rawData[BlocklistUpdateArguments.blocklistSize.argName] as num,
    );
  }
}
