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

enum TorrentRenamePathArgument {
  id(argName: "id"),
  ids(argName: "ids"),
  path(argName: "path"),
  name(argName: "name");

  final String argName;

  const TorrentRenamePathArgument({required this.argName});
}

mixin TorrentRenamePathArgsDefine {
  TorrentId get id;
  String get oldPath;
  String get newName;
}

class TorrentRenamePathArgs with TorrentRenamePathArgsDefine {
  @override
  final TorrentId id;
  @override
  final String oldPath;
  @override
  final String newName;

  const TorrentRenamePathArgs({
    required this.id,
    required this.oldPath,
    required this.newName,
  });
}

class TorrentRenamePathRequestParam
    with TorrentRenamePathArgsDefine
    implements RequestParam {
  final TorrentRenamePathArgs _args;

  @override
  TorrentId get id => _args.id;

  @override
  String get oldPath => _args.oldPath;

  @override
  String get newName => _args.newName;

  const TorrentRenamePathRequestParam(TorrentRenamePathArgs args)
      : _args = args;

  factory TorrentRenamePathRequestParam.build(
      {ServerRpcVersion? version, required TorrentRenamePathArgs args}) {
    TorrentRenamePathRequestParam normalBuilder() =>
        TorrentRenamePathRequestParam(args);
    if (version == null) {
      return normalBuilder();
    } else if (version.checkApiVersionValidate()) {
      return normalBuilder();
    } else {
      throw TransmissionVersionError(
          "Incompatible API version on torrent-rename-path",
          version.rpcVersion,
          version.minRpcVersion);
    }
  }

  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {
        TorrentRenamePathArgument.ids.argName: [id.toRpcJson()],
        TorrentRenamePathArgument.path.argName: oldPath,
        TorrentRenamePathArgument.name.argName: newName,
      };
}

class TorrentRenamePathResponseParam implements ResponseParam {
  final TorrentId id;
  final String path;
  final String name;

  const TorrentRenamePathResponseParam({
    required this.id,
    required this.path,
    required this.name,
  });

  factory TorrentRenamePathResponseParam.fromJson(JsonMap rawData) {
    return TorrentRenamePathResponseParam(
      id: TorrentId(id: rawData[TorrentRenamePathArgument.id.argName]),
      path: rawData[TorrentRenamePathArgument.path.argName] as String,
      name: rawData[TorrentRenamePathArgument.name.argName] as String,
    );
  }
}