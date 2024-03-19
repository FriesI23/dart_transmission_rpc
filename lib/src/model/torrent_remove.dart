// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../version.dart';
import 'torrent.dart';

enum TorrentRemoveArgument {
  ids(argName: "ids"),
  deleteLocalData(argName: "delete-local-data");

  final String argName;

  const TorrentRemoveArgument({required this.argName});
}

abstract class TorrentRemoveRequestParam implements RequestParam {
  final TorrentIds ids;

  /// delete local data.
  final bool? deleteLocalData;

  const TorrentRemoveRequestParam({required this.ids, this.deleteLocalData});

  factory TorrentRemoveRequestParam.build(
          {ServerRpcVersion? version,
          required TorrentIds ids,
          bool? deleteLocalData}) =>
      _TorrentRemoveRequestParam(ids: ids, deleteLocalData: deleteLocalData);
}

class _TorrentRemoveRequestParam extends TorrentRemoveRequestParam {
  _TorrentRemoveRequestParam({required super.ids, super.deleteLocalData});

  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {
        TorrentRemoveArgument.ids.argName: ids.toRpcJson(),
        if (deleteLocalData != null)
          TorrentRemoveArgument.deleteLocalData.argName: deleteLocalData,
      };
}

class TorrentRemoveResponseParam implements ResponseParam {
  const TorrentRemoveResponseParam();

  factory TorrentRemoveResponseParam.fromJson(JsonMap rawData) =>
      const TorrentRemoveResponseParam();
}
