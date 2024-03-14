// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'model/blocklist_update.dart';
import 'model/free_space.dart';
import 'model/group_get.dart';
import 'model/port_test.dart';
import 'model/queue_move.dart';
import 'model/session_get.dart';
import 'model/session_set.dart';
import 'model/session_stats.dart';
import 'request.dart';
import 'response.dart';

typedef JsonMap = Map<String, dynamic>;
typedef RpcTag = num;

// api
typedef _ApiResponse<T extends RequestParam, V extends ResponseParam>
    = TransmissionRpcResponse<V, TransmissionRpcRequest<T>>;
// session-get
typedef SessionGetResponse
    = _ApiResponse<SessionGetRequestParam, SessionGetResponseParam>;
// session-set
typedef SessionSetResponse
    = _ApiResponse<SessionSetRequestParam, SessionSetResponseParam>;
// session-stats
typedef SessionStatsResponse
    = _ApiResponse<SessionStatsRequestParam, SessionStatsResponseParam>;
// blocklist-update
typedef BlocklistUpdateResponse
    = _ApiResponse<BlocklistUpdateRequestParam, BlocklistUpdateResponseParam>;
// port-test
typedef PortTestResponse
    = _ApiResponse<PorTestRequestParam, PortTestResponseParam>;
// queue-move-*
typedef QueueMoveResponse<T extends QueueMoveRequestParam>
    = _ApiResponse<T, QueueMoveResponseParam>;
// free-space
typedef FreeSpaceResponse
    = _ApiResponse<FreeSpaceRequestParam, FreeSpaceResponseParam>;
// group-get
typedef GroupGetResponse
    = _ApiResponse<GroupGetRequestParam, GroupGetResponseParam>;
