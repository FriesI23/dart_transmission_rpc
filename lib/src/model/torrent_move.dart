// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../exception.dart';
import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../version.dart';
import 'torrent.dart';

enum TorrentSetLocationArgument {
  // torrent list
  ids(argName: "ids"),

  // the new torrent location
  location(argName: "location"),

  // if true, move from previous location.
  // otherwise, search "location" for files (default: false)
  move(argName: "move");

  final String argName;

  const TorrentSetLocationArgument({required this.argName});
}

mixin TorrentSetLocationArgsDefine {
  TorrentIds get ids;
  String get location;
  bool? get move;
}

class TorrentSetLocationArgs with TorrentSetLocationArgsDefine {
  @override
  final TorrentIds ids;
  @override
  final String location;
  @override
  final bool? move;

  const TorrentSetLocationArgs({
    required this.ids,
    required this.location,
    this.move,
  });
}

class TorrentSetLocationRequestParam
    with TorrentSetLocationArgsDefine
    implements RequestParam {
  final TorrentSetLocationArgs _arg;

  const TorrentSetLocationRequestParam({required TorrentSetLocationArgs args})
      : _arg = args;

  @override
  TorrentIds get ids => _arg.ids;

  @override
  String get location => _arg.location;

  @override
  bool? get move => _arg.move;

  factory TorrentSetLocationRequestParam.build({
    ServerRpcVersion? version,
    required TorrentSetLocationArgs args,
  }) {
    TorrentSetLocationRequestParam normalBuilder() =>
        TorrentSetLocationRequestParam(args: args);
    if (version == null) {
      return normalBuilder();
    } else if (version.checkApiVersionValidate()) {
      return normalBuilder();
    } else {
      throw TransmissionVersionError(
          "Incompatible API version on torrent-set-location",
          version.rpcVersion,
          version.minRpcVersion);
    }
  }

  @override
  String? check() {
    if (ids.isEmpty) {
      throw const TransmissionCheckError("ids must not be empty");
    }
    return null;
  }

  @override
  JsonMap toRpcJson() => {
        TorrentSetLocationArgument.ids.argName: ids.toRpcJson(),
        TorrentSetLocationArgument.location.argName: location,
        if (move != null) TorrentSetLocationArgument.move.argName: move,
      };
}

class TorrentSetLocationResponseParam implements ResponseParam {
  const TorrentSetLocationResponseParam();

  factory TorrentSetLocationResponseParam.fromJson(JsonMap rawData) =>
      const TorrentSetLocationResponseParam();
}
