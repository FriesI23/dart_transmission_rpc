// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../exception.dart';
import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';
import 'torrent.dart';

enum TorrentSetLocationArgument {
  ids(argName: "ids"),
  location(argName: "location"),
  move(argName: "move");

  final String argName;

  const TorrentSetLocationArgument({required this.argName});
}

mixin TorrentSetLocationArgsDefine {
  /// torrent list
  TorrentIds get ids;

  /// the new torrent location
  String get location;

  /// if true, move from previous location;
  /// otherwise, search "location" for files.
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
  }) =>
      buildRequestParam1(version, args,
          nullVersionBuilder: (args) =>
              TorrentSetLocationRequestParam(args: args),
          defaultVersionBuilder: (args) =>
              TorrentSetLocationRequestParam(args: args));

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
