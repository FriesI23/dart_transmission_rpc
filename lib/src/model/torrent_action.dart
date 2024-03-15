// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import 'torrent.dart';

enum TorrentActionArgument {
  ids(argName: "ids");

  final String argName;

  const TorrentActionArgument({required this.argName});
}

abstract class TorrentActionReqeustParam implements RequestParam {
  final TorrentIds ids;

  const TorrentActionReqeustParam({required this.ids});

  @override
  String? check() => ids.isEmpty ? "ids should not be empty" : null;

  @override
  JsonMap toRpcJson() => {"ids": ids.toRpcJson()};
}

class TorrentStartRequestParam extends TorrentActionReqeustParam {
  TorrentStartRequestParam({required super.ids});
}

class TorrentStartNowRequestParam extends TorrentActionReqeustParam {
  TorrentStartNowRequestParam({required super.ids});
}

class TorrentStopRequestParam extends TorrentActionReqeustParam {
  TorrentStopRequestParam({required super.ids});
}

class TorrentVerifyRequestParam extends TorrentActionReqeustParam {
  TorrentVerifyRequestParam({required super.ids});
}

class TorrentReannounceRequestParam extends TorrentActionReqeustParam {
  TorrentReannounceRequestParam({required super.ids});
}

class TorrentActionResponseParam implements ResponseParam {
  const TorrentActionResponseParam();

  factory TorrentActionResponseParam.fromJson(JsonMap rawData) =>
      const TorrentActionResponseParam();
}
