// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../client.dart';
import '../method.dart';
import '../model/torrent.dart';
import '../model/torrent_get.dart';
import '../typedef.dart';

extension TransmissionRpcTorrentExtension on TransmissionRpcClient {
  // Get torrents info
  Future<TorrentGetResponse> torrentGetAll(TorrentIds ids,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        TorrentGetRequestParam.build(
            version: serverRpcVersion, ids: ids, fields: null),
        method: TransmissionRpcMethod.torrentGet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentGetResponseParam.fromJson(rawParam),
      );
}
