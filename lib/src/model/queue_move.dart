// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import 'torrent.dart';

enum QueueMoveArgument {
  ids(argName: "ids");

  final String argName;

  const QueueMoveArgument({required this.argName});
}

abstract class QueueMoveRequestParam implements RequestParam {
  final TorrentIds ids;

  const QueueMoveRequestParam({required this.ids});

  @override
  String? check() {
    return ids.isEmpty ? "ids should not be empty" : null;
  }

  @override
  JsonMap toRpcJson() => {"ids": ids.toRpcJson()};
}

class QueueMoveTopReqeustParam extends QueueMoveRequestParam {
  QueueMoveTopReqeustParam({required super.ids});
}

class QueueMoveUpReqeustParam extends QueueMoveRequestParam {
  QueueMoveUpReqeustParam({required super.ids});
}

class QueueMoveDownReqeustParam extends QueueMoveRequestParam {
  QueueMoveDownReqeustParam({required super.ids});
}

class QueueMoveBottomReqeustParam extends QueueMoveRequestParam {
  QueueMoveBottomReqeustParam({required super.ids});
}

class QueueMoveResponseParam implements ResponseParam {
  const QueueMoveResponseParam();

  factory QueueMoveResponseParam.fromJson(JsonMap rawData) =>
      const QueueMoveResponseParam();
}
