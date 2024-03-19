// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'model/blocklist_update.dart';
import 'model/free_space.dart';
import 'model/group_get.dart';
import 'model/group_set.dart';
import 'model/port_test.dart';
import 'model/queue_move.dart';
import 'model/session_close.dart';
import 'model/session_get.dart';
import 'model/session_set.dart';
import 'model/session_stats.dart';
import 'model/torrent_action.dart';
import 'model/torrent_add.dart';
import 'model/torrent_get.dart';
import 'model/torrent_move.dart';
import 'model/torrent_remove.dart';
import 'model/torrent_rename.dart';
import 'model/torrent_set.dart';
import 'request.dart';
import 'response.dart';

typedef JsonMap = Map<String, dynamic>;
typedef RpcTag = num;
typedef TrackerId = num;
typedef TrackerList = List<List<String>>;
typedef TrackerListIter = Iterable<Iterable<String>>;

typedef ParamBuilderEntry1<S, V> = MapEntry<int, S Function(V)>;
typedef ParamBuilderEntry2<S, V1, V2> = MapEntry<int, S Function(V1, V2)>;

// api
typedef ApiResponse<T extends RequestParam, V extends ResponseParam>
    = TransmissionRpcResponse<V, TransmissionRpcRequest<T>>;
// torrent-<action>
typedef TorrentActionResponse<T extends TorrentActionReqeustParam>
    = ApiResponse<T, TorrentActionResponseParam>;
// torrent-get
typedef TorrentGetResponse
    = ApiResponse<TorrentGetRequestParam, TorrentGetResponseParam>;
// torretn-set
typedef TorrentSetResponse
    = ApiResponse<TorrentSetRequestParam, TorrentSetResponseParam>;
// torrent-remove
typedef TorrentRemoveResponse
    = ApiResponse<TorrentRemoveRequestParam, TorrentRemoveResponseParam>;
// torrent-add
typedef TorrentAddResponse
    = ApiResponse<TorrentAddRequestParam, TorrentAddResponseParam>;
// torrent-set-location
typedef TorrentSetLocationResponse = ApiResponse<TorrentSetLocationRequestParam,
    TorrentSetLocationResponseParam>;
// torrent-rename-path
typedef TorrentRenamePathResponse = ApiResponse<TorrentRenamePathRequestParam,
    TorrentRenamePathResponseParam>;
// session-get
typedef SessionGetResponse
    = ApiResponse<SessionGetRequestParam, SessionGetResponseParam>;
// session-set
typedef SessionSetResponse
    = ApiResponse<SessionSetRequestParam, SessionSetResponseParam>;
// session-stats
typedef SessionStatsResponse
    = ApiResponse<SessionStatsRequestParam, SessionStatsResponseParam>;
// blocklist-update
typedef BlocklistUpdateResponse
    = ApiResponse<BlocklistUpdateRequestParam, BlocklistUpdateResponseParam>;
// port-test
typedef PortTestResponse
    = ApiResponse<PorTestRequestParam, PortTestResponseParam>;
// session-close
typedef SessionCloseResponse
    = ApiResponse<SessionCloseRequestParam, SessionCloseResponseParam>;
// queue-move-*
typedef QueueMoveResponse<T extends QueueMoveRequestParam>
    = ApiResponse<T, QueueMoveResponseParam>;
// free-space
typedef FreeSpaceResponse
    = ApiResponse<FreeSpaceRequestParam, FreeSpaceResponseParam>;
// group-get
typedef GroupGetResponse
    = ApiResponse<GroupGetRequestParam, GroupGetResponseParam>;
// group-set
typedef GroupSetResponse
    = ApiResponse<GroupSetRequestParam, GroupSetResponseParam>;
