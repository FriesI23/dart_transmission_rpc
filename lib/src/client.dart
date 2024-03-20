// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'exception.dart';
import 'logging.dart';
import 'method.dart';
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
import 'model/torrent.dart';
import 'model/torrent_action.dart';
import 'model/torrent_add.dart';
import 'model/torrent_get.dart';
import 'model/torrent_move.dart';
import 'model/torrent_remove.dart';
import 'model/torrent_rename.dart';
import 'model/torrent_set.dart';
import 'request.dart';
import 'response.dart';
import 'typedef.dart';
import 'utils.dart';
import 'version.dart';

enum TransmissionRpcRetryReason { csrf }

/// A Transmission RPC client implemented in Dart, visit
/// [rpc-spec.md](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md)
/// obtain more information.
///
/// usage example:
/// ```dart
/// void main() async {
///   final client = TransmissionRpcClient();
///   await client.init();
///   assert(client.isInited(), true);
/// }
/// ```
abstract interface class TransmissionRpcClient {
  Uri get url;
  String? get username;
  String? get password;
  ServerRpcVersion? get serverRpcVersion;
  int get maxRetryCount;
  int get timeout;

  /// Start a torrent.
  /// more info see:
  /// [torrent-start](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests)
  ///
  /// use [TorrentIds.empty] apply for all torrents;
  Future<TorrentActionResponse<TorrentStartRequestParam>> torrentStart(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Start start torrent disregarding queue position.
  /// more info see:
  /// [torrent-start-now](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests)
  ///
  /// use [TorrentIds.empty] apply for all torrents;
  Future<TorrentActionResponse<TorrentStartNowRequestParam>> torrentStartNow(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Stop torrent.
  /// more info see:
  /// [torrent-stop](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests)
  ///
  /// use [TorrentIds.empty] apply for all torrents;
  Future<TorrentActionResponse<TorrentStopRequestParam>> torrentStop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Verify torrent.
  /// more info see:
  /// [torrent-verify](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests)
  ///
  /// use [TorrentIds.empty] apply for all torrents;
  Future<TorrentActionResponse<TorrentVerifyRequestParam>> torrentVerify(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Re-announce to trackers now.
  /// more info see:
  /// [torrent-reannounce](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests)
  ///
  /// use [TorrentIds.empty] apply for all torrents;
  Future<TorrentActionResponse<TorrentReannounceRequestParam>>
      torrentReannounce(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Get torrents info.
  /// more info see:
  /// [torrent-get](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#33-torrent-accessor-torrent-get)
  ///
  /// leave [ids] null or use [TorrentIds.empty] apply for all torrents;
  ///
  ///
  /// If [ids] are set to [TorrentIds.recently], then response set
  /// [TorrentGetResponseParam.removed] with only the 'id' field of recently
  /// removed torrents.
  Future<TorrentGetResponse> torrentGet(List<TorrentGetArgument> fields,
      {TorrentIds? ids, RpcTag? tag, int? timeout});

  /// Set torrents info.
  /// more info see:
  /// [torrent-set](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#32-torrent-mutator-torrent-set)
  ///
  /// set [TorrentIds.torrentSetForAll] on [ids] to apply changes for
  /// all torrents;
  ///
  /// set [FileIndices.empty] on [filesWanted]/[filesUnwanted]/
  /// [priorityHigh]/[priorityNormal]/[priorityLow] to fetch
  /// "all files";
  Future<TorrentSetResponse> torrentSet(TorrentSetRequestArgs args,
      {RpcTag? tag, int? timeout});

  /// Removing a torrent.
  /// more info see: [torrent-remove](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#35-removing-a-torrent)
  ///
  /// If [deleteLocalData] is not passed, server default behavior will be used;
  Future<TorrentRemoveResponse> torrentRemove(TorrentIds ids,
      {bool? deleteLocalData, RpcTag? tag, int? timeout});

  /// Adding a torrent.
  /// more info see: [torrent-add](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#34-adding-a-torrent)
  ///
  /// [TorrentAddFileInfo] should only set `filename` or `metainfo`,
  /// only `filename` will take effect if both are set;
  ///
  /// resonse [TorrentAddResponseParam.isDuplicated] will be true when
  /// attempting to add a duplicate torrent;
  Future<TorrentAddResponse> torrentAdd(TorrentAddRequestArgs args,
      {RpcTag? tag, int? timeout});

  /// Moving a torrent.
  /// more info see: [torrent-set-location](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#36-moving-a-torrent)
  ///
  /// If [move] param not passed, server default behavior will be used;
  Future<TorrentSetLocationResponse> torrentSetLocation(
      TorrentSetLocationArgs args,
      {RpcTag? tag,
      int? timeout});

  /// Renaming a torrent's path.
  /// more info see: [torrent-rename-path](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#37-renaming-a-torrents-path)
  ///
  /// e.g. a torrent struct:
  /// ```text
  /// linux
  ///   - checksum
  ///   - linux.iso
  /// ```
  ///
  /// call:
  /// ```dart
  /// final args = TorrentRenamePathArgs(
  ///   id: TorrentId(id: 1),
  ///   oldPath: "linux",
  ///   newName: "foo",
  /// );
  /// await torrentSetLocation(args);
  /// ```
  /// will rename `linux` folder as `foo`, new torrent path struct:
  /// ```
  /// foo # origin name `linux`
  ///   - checksum
  ///   - linux.iso
  /// ```
  ///
  /// call:
  /// ```dart
  /// final args = TorrentRenamePathArgs(
  ///   id: TorrentId(id: 1),
  ///   oldPath: "linux/checksum",
  ///   newName: "foo",
  /// );
  /// await torrentSetLocation(args);
  /// ```
  /// will rename `checksum` file as `foo`, new torrent path struct:
  /// ```
  /// linux
  ///   - foo # origin name `checksum`
  ///   - linux.iso
  /// ```
  ///
  /// call [torrentGet] again if wat to update torrent's `files` and `name`;
  Future<TorrentRenamePathResponse> torrentRenamePath(
      TorrentRenamePathArgs args,
      {RpcTag? tag,
      int? timeout});

  /// Get session running stats by given fields.
  /// more info see: [session-get](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#412-accessors)
  Future<SessionGetResponse> sessionGet(List<SessionGetArgument>? fields,
      {RpcTag? tag, int? timeout});

  /// Set sesion running stats.
  /// more info see: [session-set](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#411-mutators)
  Future<SessionSetResponse> sessionSet(SessionSetRequestArgs args,
      {RpcTag? tag, int? timeout});

  /// Get sssion statistics
  /// more info see: [session-stats](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#42-session-statistics)
  Future<SessionStatsResponse> sessionStats({RpcTag? tag, int? timeout});

  /// Update blocklist (if setting blocklist-url).
  /// more info see: [blocklist-update](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#43-blocklist)
  Future<BlocklistUpdateResponse> blocklistUpdate({RpcTag? tag, int? timeout});

  /// Test to see if your incoming peer port is accessible.
  /// more info see: [port-test](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#44-port-checking)
  Future<PortTestResponse> portTest({RpcTag? tag, int? timeout});

  /// Tells the transmission session to shutdown.
  /// more info see: [session-close](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#45-session-shutdown)
  Future<SessionCloseResponse> sessionClose({RpcTag? tag, int? timeout});

  /// Move torretns at top of queue.
  /// more info see: [queue-move-top](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#46-queue-movement-requests)
  Future<QueueMoveResponse<QueueMoveTopReqeustParam>> queueMoveTop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Move torrents up from queue.
  /// more info see: [queue-move-up](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#46-queue-movement-requests)
  Future<QueueMoveResponse<QueueMoveUpReqeustParam>> queueMoveUp(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Move torrent down from queue.
  /// more info see: [queue-move-down](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#46-queue-movement-requests)
  Future<QueueMoveResponse<QueueMoveDownReqeustParam>> queueMoveDown(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Move torrent at bottom of queue.
  /// more info see: [queue-move-bottom](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#46-queue-movement-requests)
  Future<QueueMoveResponse<QueueMoveBottomReqeustParam>> queueMoveBottom(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  /// Tests how much free space is available in a client-specified folder.
  /// more info see: [free-space](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#47-free-space)
  Future<FreeSpaceResponse> freeSpace(String path, {RpcTag? tag, int? timeout});

  /// Get bandwidth group.
  /// more info see: [group-get](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#482-bandwidth-group-accessor-group-get)
  ///
  /// [group] is a list of bandwidth group desc name, you can apply group by
  /// setting `TorrentSetRequestArgs(group: "group_name")` on [torrentSet];
  Future<GroupGetResponse> groupGet(List<String>? group,
      {RpcTag? tag, int? timeout});

  /// Set bandwith group
  /// more info see: [group-set](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#481-bandwidth-group-mutator-group-set)
  Future<GroupSetResponse> groupSet(GroupSetRequestArgs args,
      {RpcTag? tag, int? timeout});

  Future<void> init();
  bool isInited();
  void preCheck(TransmissionRpcMethod method, RequestParam? p, {int? timeout});
  Future<JsonMap> doRequest(TransmissionRpcRequest request, {int? timeout});

  factory TransmissionRpcClient({
    HttpProtocol protocol = HttpProtocol.http,
    String? username,
    String? password,
    String host = "127.0.0.1",
    int port = 9091,
    String path = "/transmission/rpc",
    int maxRetryCount = 10,
    int timeout = 10000,
    Logger? log,
  }) =>
      _TransmissionRpcClient(
        url: Uri(scheme: protocol.name, host: host, port: port, path: path),
        username: username,
        password: password,
        httpClient: HttpClient(),
        maxRetryCount: maxRetryCount,
        timeout: timeout,
        log: log,
      );
}

class _TransmissionRpcClient implements TransmissionRpcClient {
  static const defaultCredentialRealm = "Transmission";
  static const defaultSessionId = "0";
  static const sesionIdHeaderKey = "X-Transmission-Session-Id";

  final Logger log;

  final HttpClient httpClient;
  @override
  final int maxRetryCount;
  @override
  final int timeout;
  @override
  final Uri url;
  @override
  final String? username;
  @override
  final String? password;

  late final ServerRpcVersion _serverRpcVersion;

  String _sessionId = defaultSessionId;
  bool _inited = false;
  Future? _initIsWorking;

  _TransmissionRpcClient({
    required this.url,
    required this.httpClient,
    required this.username,
    required this.password,
    required this.maxRetryCount,
    required this.timeout,
    Logger? log,
  })  : assert(maxRetryCount >= 0 && maxRetryCount <= 100),
        assert(timeout > 0),
        log = log ?? Logger("TransmissionRpcClient") {
    _initHttpCredential();
  }

  void _initHttpCredential() {
    if (username != null || password != null) {
      final credentials =
          HttpClientBasicCredentials(username ?? '', password ?? '');
      httpClient.addCredentials(url, defaultCredentialRealm, credentials);
    }
  }

  @override
  Future<void> init() async {
    if (isInited()) {
      throw const TransmissionError("don't repeated init");
    }
    if (_initIsWorking != null) {
      log.info("already in init progress, waiting complete...",
          args: [_sessionId, _inited]);
      await _initIsWorking;
      return;
    }

    final completer = Completer();
    _initIsWorking = completer.future;

    final response = await _fetchBasicInfo();

    completer.complete();
    _initIsWorking = null;

    if (!response.isOk() ||
        response.param?.rpcVersion == null ||
        response.param?.rpcVersionMinimum == null) {
      throw TransmissionError("init client failed, reason: ${response.result}");
    }
    final serverRpcVersion = ServerRpcVersion.build(
      response.param!.rpcVersion!,
      response.param!.rpcVersionMinimum!,
    );
    if (!serverRpcVersion.isValidateServerVersion()) {
      throw TransmissionVersionError("init server check failed",
          serverRpcVersion.rpcVersion, serverRpcVersion.minRpcVersion);
    }
    // init completed
    _serverRpcVersion = serverRpcVersion;
    _inited = true;
    log.debug("init complete",
        args: [_sessionId, _serverRpcVersion, _initIsWorking]);
  }

  Future<SessionGetResponse> _fetchBasicInfo({RpcTag? tag, int? timeout}) =>
      callApi(
        SessionGetRequestParam.build(fields: const [
          SessionGetArgument.rpcVersion,
          SessionGetArgument.rpcVersionMinimum,
        ]),
        method: TransmissionRpcMethod.sessionGet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            SessionGetResponseParam.fromJson(rawParam),
      );

  @override
  bool isInited() => _inited;

  @override
  ServerRpcVersion? get serverRpcVersion => _inited ? _serverRpcVersion : null;

  @override
  Future<JsonMap> doRequest(TransmissionRpcRequest request,
      {int? timeout}) async {
    final payload = jsonEncode(request.toRpcJson());
    final body = utf8.encode(payload);
    log.debug("doReqeust", args: [
      request.hashCode,
      request.method,
      request.param,
      _sessionId,
      payload
    ]);
    final resultText = await _doRequest(Uint8List.fromList(body),
        Duration(milliseconds: timeout ?? this.timeout));
    log.debug("on doReqeust", args: [
      request.hashCode,
      request.method,
      request.param,
      _sessionId,
      resultText
    ]);
    final rawText = jsonDecode(resultText);
    return rawText;
  }

  Future<String> _doRequest(
    Uint8List body,
    Duration timeout, {
    Duration usedTime = Duration.zero,
    int retryCount = 0,
    List<TransmissionRpcRetryReason>? retryReasonList,
  }) async {
    if (retryCount > maxRetryCount) {
      throw TranmissionMaxRetryRequestError(
          "request retry count overlimit, $retryReasonList", retryCount);
    }

    final lastTime = timeout - usedTime;
    if (lastTime.isNegative) {
      throw TransmissionTimeoutError(
          "timeout with reqeust: ${utf8.decode(body)}");
    }

    final stopWatch = Stopwatch();
    final HttpClientResponse httpResponse;
    HttpClientRequest? httpRequest;

    try {
      stopWatch.start();
      httpRequest = await httpClient.postUrl(url);
      httpRequest.headers.add(sesionIdHeaderKey, _sessionId);
      httpRequest.add(body);
      httpResponse = await httpRequest.close().timeout(lastTime);
    } on HttpException catch (e) {
      throw TranmissionConnectionError(
          "can't connect to transmission server: ${e.toString()}");
    } on SocketException catch (e) {
      throw TranmissionConnectionError(
          "can't connect to transmission server: ${e.toString()}");
    } on TimeoutException catch (e) {
      httpRequest?.abort();
      throw TransmissionTimeoutError(
          "timeout when try connect to transmission server: ${e.toString()}");
    } finally {
      stopWatch.stop();
    }

    log.debug("on http request complete",
        args: [_sessionId, httpResponse.statusCode, httpRequest.uri]);
    _sessionId = httpResponse.headers.value(sesionIdHeaderKey) ?? _sessionId;

    final httpCode = httpResponse.statusCode;
    switch (httpCode) {
      case 401:
      case 403:
        throw TransmissionAuthError(
            "transmission server required auth, code: $httpCode");
      case 409:
        retryReasonList = retryReasonList ?? <TransmissionRpcRetryReason>[];
        final newRetryCount =
            retryReasonList.lastOrNull == TransmissionRpcRetryReason.csrf
                ? retryCount + 1
                : retryCount;
        final newUseTime =
            retryReasonList.lastOrNull == TransmissionRpcRetryReason.csrf
                ? usedTime + stopWatch.elapsed
                : usedTime;
        retryReasonList.add(TransmissionRpcRetryReason.csrf);
        log.info("409 resend reqeust",
            args: [_sessionId, retryReasonList, httpRequest.uri]);
        return _doRequest(body, timeout,
            usedTime: newUseTime,
            retryCount: newRetryCount,
            retryReasonList: retryReasonList);
    }

    return httpResponse.transform(utf8.decoder).join();
  }

  @override
  void preCheck(TransmissionRpcMethod method, RequestParam? p, {int? timeout}) {
    if (!isInited()) {
      throw const TransmissionCheckError("Client has not been initialized.");
    }

    String buildFailedString(String reason) =>
        "preCheck failed, method: $method, reason: $reason";

    if (timeout != null && timeout < 0) {
      throw TransmissionCheckError(buildFailedString("timeout $timeout <= 0"));
    }
    try {
      final reason = p?.check();
      if (reason != null && reason.isNotEmpty) {
        log.warn(buildFailedString(reason));
      }
    } on TransmissionError catch (e) {
      throw TransmissionCheckError(buildFailedString(e.toString()));
    }
  }

  @override
  Future<SessionGetResponse> sessionGet(List<SessionGetArgument>? fields,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        SessionGetRequestParam.build(version: serverRpcVersion, fields: fields),
        method: TransmissionRpcMethod.sessionGet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            SessionGetResponseParam.fromJson(rawParam),
      );

  @override
  Future<SessionSetResponse> sessionSet(SessionSetRequestArgs args,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        SessionSetRequestParam.build(version: serverRpcVersion, args: args),
        method: TransmissionRpcMethod.sessionSet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            SessionSetResponseParam.fromJson(rawParam),
      );

  @override
  Future<SessionStatsResponse> sessionStats({RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        null,
        method: TransmissionRpcMethod.sessionStats,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            SessionStatsResponseParam.fromJson(rawParam),
      );

  @override
  Future<BlocklistUpdateResponse> blocklistUpdate(
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        null,
        method: TransmissionRpcMethod.blocklistUpdate,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            BlocklistUpdateResponseParam.fromJson(rawParam),
      );

  @override
  Future<PortTestResponse> portTest({RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        null,
        method: TransmissionRpcMethod.portTest,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            PortTestResponseParam.fromJson(rawParam),
      );

  @override
  Future<QueueMoveResponse<QueueMoveBottomReqeustParam>> queueMoveBottom(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) =>
      checkAndCallApi(
        QueueMoveBottomReqeustParam(ids: ids),
        method: TransmissionRpcMethod.queueMoveBottom,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            QueueMoveResponseParam.fromJson(rawParam),
      );
  @override
  Future<QueueMoveResponse<QueueMoveDownReqeustParam>> queueMoveDown(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) =>
      checkAndCallApi(
        QueueMoveDownReqeustParam(ids: ids),
        method: TransmissionRpcMethod.queueMoveDown,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            QueueMoveResponseParam.fromJson(rawParam),
      );

  @override
  Future<QueueMoveResponse<QueueMoveTopReqeustParam>> queueMoveTop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) =>
      checkAndCallApi(
        QueueMoveTopReqeustParam(ids: ids),
        method: TransmissionRpcMethod.queueMoveTop,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            QueueMoveResponseParam.fromJson(rawParam),
      );

  @override
  Future<QueueMoveResponse<QueueMoveUpReqeustParam>> queueMoveUp(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) =>
      checkAndCallApi(
        QueueMoveUpReqeustParam(ids: ids),
        method: TransmissionRpcMethod.queueMoveUp,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            QueueMoveResponseParam.fromJson(rawParam),
      );

  @override
  Future<FreeSpaceResponse> freeSpace(String path,
      {RpcTag? tag, int? timeout}) {
    final v = serverRpcVersion;
    return checkAndCallApi(
      FreeSpaceRequestParam.build(version: v, path: path),
      method: TransmissionRpcMethod.freeSpace,
      tag: tag,
      timeout: timeout,
      responseParamBuilder: (rawParam) =>
          FreeSpaceResponseParam.fromJson(rawParam, v: v),
    );
  }

  @override
  Future<GroupGetResponse> groupGet(List<String>? group,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        GroupGetRequestParam.build(version: serverRpcVersion, group: group),
        method: TransmissionRpcMethod.groupGet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            GroupGetResponseParam.fromJson(rawParam),
      );

  @override
  Future<GroupSetResponse> groupSet(GroupSetRequestArgs args,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        GroupSetRequestParam.build(version: serverRpcVersion, args: args),
        method: TransmissionRpcMethod.groupSet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            GroupSetResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentActionResponse<TorrentReannounceRequestParam>>
      torrentReannounce(TorrentIds ids, {RpcTag? tag, int? timeout}) =>
          checkAndCallApi(
            TorrentReannounceRequestParam(ids: ids),
            method: TransmissionRpcMethod.torrentReannounce,
            tag: tag,
            timeout: timeout,
            responseParamBuilder: (rawParam) =>
                TorrentActionResponseParam.fromJson(rawParam),
          );

  @override
  Future<TorrentActionResponse<TorrentStartRequestParam>> torrentStart(
          TorrentIds ids,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentStartRequestParam(ids: ids),
        method: TransmissionRpcMethod.torrentStart,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentActionResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentActionResponse<TorrentStartNowRequestParam>> torrentStartNow(
          TorrentIds ids,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentStartNowRequestParam(ids: ids),
        method: TransmissionRpcMethod.torrentStartNow,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentActionResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentActionResponse<TorrentStopRequestParam>> torrentStop(
          TorrentIds ids,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentStopRequestParam(ids: ids),
        method: TransmissionRpcMethod.torrentStop,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentActionResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentActionResponse<TorrentVerifyRequestParam>> torrentVerify(
          TorrentIds ids,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentVerifyRequestParam(ids: ids),
        method: TransmissionRpcMethod.torrentVerify,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentActionResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentGetResponse> torrentGet(List<TorrentGetArgument> fields,
          {TorrentIds? ids, RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        TorrentGetRequestParam.build(
            version: serverRpcVersion, fields: fields, ids: ids),
        method: TransmissionRpcMethod.torrentGet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentGetResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentSetResponse> torrentSet(TorrentSetRequestArgs args,
          {RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        TorrentSetRequestParam.build(version: serverRpcVersion, args: args),
        method: TransmissionRpcMethod.torrentSet,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentSetResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentRemoveResponse> torrentRemove(TorrentIds<TorrentId> ids,
          {bool? deleteLocalData, RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        TorrentRemoveRequestParam.build(version: serverRpcVersion, ids: ids),
        method: TransmissionRpcMethod.torrentRemove,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentRemoveResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentAddResponse> torrentAdd(TorrentAddRequestArgs args,
      {RpcTag? tag, int? timeout}) {
    final v = serverRpcVersion;
    return checkAndCallApi(
      TorrentAddRequestParam.build(args: args, version: v),
      method: TransmissionRpcMethod.torrentAdd,
      tag: tag,
      timeout: timeout,
      responseParamBuilder: (rawParam) =>
          TorrentAddResponseParam.fromJson(rawParam, version: v),
    );
  }

  @override
  Future<TorrentSetLocationResponse> torrentSetLocation(
          TorrentSetLocationArgs args,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentSetLocationRequestParam.build(
            args: args, version: serverRpcVersion),
        method: TransmissionRpcMethod.torrentSetLocation,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentSetLocationResponseParam.fromJson(rawParam),
      );

  @override
  Future<TorrentRenamePathResponse> torrentRenamePath(
          TorrentRenamePathArgs args,
          {RpcTag? tag,
          int? timeout}) =>
      checkAndCallApi(
        TorrentRenamePathRequestParam.build(
            args: args, version: serverRpcVersion),
        method: TransmissionRpcMethod.torrentRenamePath,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            TorrentRenamePathResponseParam.fromJson(rawParam),
      );

  @override
  Future<SessionCloseResponse> sessionClose({RpcTag? tag, int? timeout}) =>
      checkAndCallApi(
        const SessionCloseRequestParam(),
        method: TransmissionRpcMethod.sessionClose,
        tag: tag,
        timeout: timeout,
        responseParamBuilder: (rawParam) =>
            SessionCloseResponseParam.fromJson(rawParam),
      );
}

extension TransmissionRpcClientFrameExtension on TransmissionRpcClient {
  Future<ApiResponse<T, V>>
      callApi<T extends RequestParam, V extends ResponseParam>(
    T? p, {
    required TransmissionRpcMethod method,
    required RpcTag? tag,
    required int? timeout,
    V Function(JsonMap rawParam)? responseParamBuilder,
  }) async {
    final request = TransmissionRpcRequest(method: method, param: p, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: TransmissionRpcResponse.isSucceed(rawResult) && rawParam is JsonMap
          ? responseParamBuilder?.call(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  Future<ApiResponse<T, V>>
      checkAndCallApi<T extends RequestParam, V extends ResponseParam>(
    T? p, {
    required TransmissionRpcMethod method,
    required RpcTag? tag,
    required int? timeout,
    V Function(JsonMap rawParam)? responseParamBuilder,
  }) async {
    preCheck(method, p, timeout: timeout);
    return callApi(
      p,
      method: method,
      tag: tag,
      timeout: timeout,
      responseParamBuilder: responseParamBuilder,
    );
  }
}
