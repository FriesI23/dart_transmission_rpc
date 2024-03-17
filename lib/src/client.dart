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

abstract interface class TransmissionRpcClient {
  Uri get url;
  String? get username;
  String? get password;
  ServerRpcVersion? get serverRpcVersion;
  int get maxRetryCount;
  int get timeout;

  // Start torrent
  Future<TorrentActionResponse<TorrentStartRequestParam>> torrentStart(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Start start torrent disregarding queue position
  Future<TorrentActionResponse<TorrentStartNowRequestParam>> torrentStartNow(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Stop torrent
  Future<TorrentActionResponse<TorrentStopRequestParam>> torrentStop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Verify torrent
  Future<TorrentActionResponse<TorrentVerifyRequestParam>> torrentVerify(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Re-announce to trackers now
  Future<TorrentActionResponse<TorrentReannounceRequestParam>>
      torrentReannounce(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Get torrents info
  Future<TorrentGetResponse> torrentGet(List<TorrentGetArgument> fields,
      {TorrentIds? ids, RpcTag? tag, int? timeout});

  // Set torrents info
  Future<TorrentSetResponse> torrentSet(TorrentSetRequestArgs args,
      {RpcTag? tag, int? timeout});

  // Removing a torrent
  Future<TorrentRemoveResponse> torrentRemove(TorrentIds ids,
      {bool? deleteLocalData, RpcTag? tag, int? timeout});

  // Add a torrent
  Future<TorrentAddResponse> torrentAdd(TorrentAddRequestArgs args,
      {RpcTag? tag, int? timeout});

  // Moving a torrent
  Future<TorrentSetLocationResponse> torrentSetLocation(
      TorrentSetLocationArgs args,
      {RpcTag? tag,
      int? timeout});

  // Renaming a torrent's path
  Future<TorrentRenamePathResponse> torrentRenamePath(
      TorrentRenamePathArgs args,
      {RpcTag? tag,
      int? timeout});

  // Get session running stats by given fields
  Future<SessionGetResponse> sessionGet(List<SessionGetArgument>? fields,
      {RpcTag? tag, int? timeout});

  // Set sesion running stats
  Future<SessionSetResponse> sessionSet(SessionSetRequestArgs args,
      {RpcTag? tag, int? timeout});

  // Get sssion statistics
  Future<SessionStatsResponse> sessionStats({RpcTag? tag, int? timeout});

  // Update blocklist (if setting blocklist-url)
  Future<BlocklistUpdateResponse> blocklistUpdate({RpcTag? tag, int? timeout});

  // Test to see if your incoming peer port is accessible.
  Future<PortTestResponse> portTest({RpcTag? tag, int? timeout});

  // Move torretns at top of queue
  Future<QueueMoveResponse<QueueMoveTopReqeustParam>> queueMoveTop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Move torrents up from queue
  Future<QueueMoveResponse<QueueMoveUpReqeustParam>> queueMoveUp(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Move torrent down from queue
  Future<QueueMoveResponse<QueueMoveDownReqeustParam>> queueMoveDown(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Move torrent at bottom of queue
  Future<QueueMoveResponse<QueueMoveBottomReqeustParam>> queueMoveBottom(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  });

  // Tests how much free space is available in a client-specified folder
  Future<FreeSpaceResponse> freeSpace(String path, {RpcTag? tag, int? timeout});

  // Get bandwidth group
  Future<GroupGetResponse> groupGet(List<String>? group,
      {RpcTag? tag, int? timeout});

  // Set bandwith group
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

    final response = await _sessionGet(
        SessionGetRequestParam.build(fields: const [
          SessionGetArgument.rpcVersion,
          SessionGetArgument.rpcVersionMinimum,
        ]),
        tag: null,
        timeout: null);

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
    final resultText =
        await _doRequest(body, Duration(milliseconds: timeout ?? this.timeout));
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
    if (timeout != null && timeout < 0) {
      throw TransmissionCheckError(
          "pre check failed, method: $method, reason: timeout $timeout <= 0");
    }
    try {
      final reason = p?.check();
      if (reason != null && reason.isNotEmpty) {
        log.warn("per check failed, method: $method, reason: $reason");
      }
    } on TransmissionError catch (e) {
      throw TransmissionCheckError(
          "pre check failed, method: $method, reason: $e");
    }
  }

  @override
  Future<SessionGetResponse> sessionGet(List<SessionGetArgument>? fields,
      {RpcTag? tag, int? timeout}) {
    final p = SessionGetRequestParam.build(
      version: serverRpcVersion,
      fields: fields,
    );
    preCheck(TransmissionRpcMethod.sessionGet, p, timeout: timeout);
    return _sessionGet(p, tag: tag, timeout: timeout);
  }

  Future<SessionGetResponse> _sessionGet(SessionGetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        method: TransmissionRpcMethod.sessionGet, param: p, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: TransmissionRpcResponse.isSucceed(rawResult) && rawParam is JsonMap
          ? SessionGetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<SessionSetResponse> sessionSet(SessionSetRequestArgs args,
      {RpcTag? tag, int? timeout}) {
    final p = SessionSetRequestParam.build(
      version: serverRpcVersion,
      args: args,
    );
    preCheck(TransmissionRpcMethod.sessionSet, p, timeout: timeout);
    return _sessionSet(p, tag: tag, timeout: timeout);
  }

  Future<SessionSetResponse> _sessionSet(SessionSetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        method: TransmissionRpcMethod.sessionSet, param: p, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: TransmissionRpcResponse.isSucceed(rawResult) && rawParam is JsonMap
          ? SessionSetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<SessionStatsResponse> sessionStats({RpcTag? tag, int? timeout}) {
    preCheck(TransmissionRpcMethod.sessionStats, null, timeout: timeout);
    return _sessionStats(tag: tag, timeout: timeout);
  }

  Future<SessionStatsResponse> _sessionStats(
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest<SessionStatsRequestParam>(
        method: TransmissionRpcMethod.sessionStats, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: TransmissionRpcResponse.isSucceed(rawResult) && rawParam is JsonMap
          ? SessionStatsResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<BlocklistUpdateResponse> blocklistUpdate({RpcTag? tag, int? timeout}) {
    preCheck(TransmissionRpcMethod.blocklistUpdate, null, timeout: timeout);
    return _blocklistUpdate(tag: tag, timeout: timeout);
  }

  Future<BlocklistUpdateResponse> _blocklistUpdate(
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest<BlocklistUpdateRequestParam>(
        method: TransmissionRpcMethod.blocklistUpdate, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: TransmissionRpcResponse.isSucceed(rawResult) && rawParam is JsonMap
          ? BlocklistUpdateResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<PortTestResponse> portTest({RpcTag? tag, int? timeout}) {
    preCheck(TransmissionRpcMethod.portTest, null, timeout: timeout);
    return _portTest(tag: tag, timeout: timeout);
  }

  Future<PortTestResponse> _portTest(
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest<PorTestRequestParam>(
        method: TransmissionRpcMethod.portTest, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? PortTestResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<QueueMoveResponse<QueueMoveBottomReqeustParam>> queueMoveBottom(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) {
    const method = TransmissionRpcMethod.queueMoveBottom;
    final p = QueueMoveBottomReqeustParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _queueMove(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<QueueMoveResponse<QueueMoveDownReqeustParam>> queueMoveDown(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) {
    const method = TransmissionRpcMethod.queueMoveDown;
    final p = QueueMoveDownReqeustParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _queueMove(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<QueueMoveResponse<QueueMoveTopReqeustParam>> queueMoveTop(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) {
    const method = TransmissionRpcMethod.queueMoveTop;
    final p = QueueMoveTopReqeustParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _queueMove(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<QueueMoveResponse<QueueMoveUpReqeustParam>> queueMoveUp(
    TorrentIds ids, {
    RpcTag? tag,
    int? timeout,
  }) {
    const method = TransmissionRpcMethod.queueMoveUp;
    final p = QueueMoveUpReqeustParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _queueMove(method, p, tag: tag, timeout: timeout);
  }

  Future<QueueMoveResponse<T>> _queueMove<T extends QueueMoveRequestParam>(
      TransmissionRpcMethod method, T p,
      {required RpcTag? tag, required int? timeout}) async {
    final request =
        TransmissionRpcRequest<T>(param: p, method: method, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? QueueMoveResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<FreeSpaceResponse> freeSpace(String path,
      {RpcTag? tag, int? timeout}) {
    final v = serverRpcVersion;
    final p = FreeSpaceRequestParam.build(path: path, version: v);
    preCheck(TransmissionRpcMethod.freeSpace, p, timeout: timeout);
    return _freeSpace(p, tag: tag, timeout: timeout, v: v);
  }

  Future<FreeSpaceResponse> _freeSpace(FreeSpaceRequestParam p,
      {required RpcTag? tag,
      required int? timeout,
      required ServerRpcVersion? v}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.freeSpace, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? FreeSpaceResponseParam.fromJson(rawParam, v: v)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<GroupGetResponse> groupGet(List<String>? group,
      {RpcTag? tag, int? timeout}) {
    final p = GroupGetRequestParam.build(
      version: serverRpcVersion,
      group: group,
    );
    preCheck(TransmissionRpcMethod.groupGet, p, timeout: timeout);
    return _groupGet(p, tag: tag, timeout: timeout);
  }

  Future<GroupGetResponse> _groupGet(GroupGetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.groupGet, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? GroupGetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<GroupSetResponse> groupSet(GroupSetRequestArgs args,
      {RpcTag? tag, int? timeout}) {
    final p = GroupSetRequestParam.build(version: serverRpcVersion, args: args);
    preCheck(TransmissionRpcMethod.groupSet, p, timeout: timeout);
    return _groupSet(p, tag: tag, timeout: timeout);
  }

  Future<GroupSetResponse> _groupSet(GroupSetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.groupSet, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? GroupSetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentActionResponse<TorrentReannounceRequestParam>>
      torrentReannounce(TorrentIds ids, {RpcTag? tag, int? timeout}) {
    const method = TransmissionRpcMethod.torrentReannounce;
    final p = TorrentReannounceRequestParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _torrentAction(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<TorrentActionResponse<TorrentStartRequestParam>> torrentStart(
      TorrentIds ids,
      {RpcTag? tag,
      int? timeout}) {
    const method = TransmissionRpcMethod.torrentStart;
    final p = TorrentStartRequestParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _torrentAction(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<TorrentActionResponse<TorrentStartNowRequestParam>> torrentStartNow(
      TorrentIds ids,
      {RpcTag? tag,
      int? timeout}) {
    const method = TransmissionRpcMethod.torrentStartNow;
    final p = TorrentStartNowRequestParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _torrentAction(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<TorrentActionResponse<TorrentStopRequestParam>> torrentStop(
      TorrentIds ids,
      {RpcTag? tag,
      int? timeout}) {
    const method = TransmissionRpcMethod.torrentStop;
    final p = TorrentStopRequestParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _torrentAction(method, p, tag: tag, timeout: timeout);
  }

  @override
  Future<TorrentActionResponse<TorrentVerifyRequestParam>> torrentVerify(
      TorrentIds ids,
      {RpcTag? tag,
      int? timeout}) {
    const method = TransmissionRpcMethod.torrentVerify;
    final p = TorrentVerifyRequestParam(ids: ids);
    preCheck(method, p, timeout: timeout);
    return _torrentAction(method, p, tag: tag, timeout: timeout);
  }

  Future<TorrentActionResponse<T>>
      _torrentAction<T extends TorrentActionReqeustParam>(
          TransmissionRpcMethod method, T p,
          {required RpcTag? tag, required int? timeout}) async {
    final request =
        TransmissionRpcRequest<T>(param: p, method: method, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentActionResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentGetResponse> torrentGet(List<TorrentGetArgument> fields,
      {TorrentIds? ids, RpcTag? tag, int? timeout}) {
    final p = TorrentGetRequestParam.build(
        version: serverRpcVersion, fields: fields, ids: ids);
    preCheck(TransmissionRpcMethod.torrentGet, p, timeout: timeout);
    return _torrentGet(p, tag: tag, timeout: timeout);
  }

  Future<TorrentGetResponse> _torrentGet(TorrentGetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentGet, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentGetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentSetResponse> torrentSet(TorrentSetRequestArgs args,
      {RpcTag? tag, int? timeout}) {
    final p = TorrentSetRequestParam.build(
      version: serverRpcVersion,
      args: args,
    );
    preCheck(TransmissionRpcMethod.torrentSet, p, timeout: timeout);
    return _torrentSet(p, tag: tag, timeout: timeout);
  }

  Future<TorrentSetResponse> _torrentSet(TorrentSetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentSet, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentSetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentRemoveResponse> torrentRemove(TorrentIds<TorrentId> ids,
      {bool? deleteLocalData, RpcTag? tag, int? timeout}) {
    final p = TorrentRemoveRequestParam.build(
      version: serverRpcVersion,
      ids: ids,
    );
    preCheck(TransmissionRpcMethod.torrentRemove, p, timeout: timeout);
    return _torrentRemove(p, tag: tag, timeout: timeout);
  }

  Future<TorrentRemoveResponse> _torrentRemove(TorrentRemoveRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentRemove, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentRemoveResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentAddResponse> torrentAdd(TorrentAddRequestArgs args,
      {RpcTag? tag, int? timeout}) {
    final v = serverRpcVersion;
    final p = TorrentAddRequestParam.build(args: args, version: v);
    preCheck(TransmissionRpcMethod.torrentAdd, p, timeout: timeout);
    return _torrentAdd(p, tag: tag, timeout: timeout, v: v);
  }

  Future<TorrentAddResponse> _torrentAdd(TorrentAddRequestParam p,
      {required RpcTag? tag,
      required int? timeout,
      required ServerRpcVersion? v}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentAdd, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentAddResponseParam.fromJson(rawParam, version: v)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentSetLocationResponse> torrentSetLocation(
      TorrentSetLocationArgs args,
      {RpcTag? tag,
      int? timeout}) {
    final p = TorrentSetLocationRequestParam.build(
        args: args, version: serverRpcVersion);
    preCheck(TransmissionRpcMethod.torrentSetLocation, p, timeout: timeout);
    return _torrentSetLocation(p, tag: tag, timeout: timeout);
  }

  Future<TorrentSetLocationResponse> _torrentSetLocation(
      TorrentSetLocationRequestParam p,
      {required RpcTag? tag,
      required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentSetLocation, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentSetLocationResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }

  @override
  Future<TorrentRenamePathResponse> torrentRenamePath(
      TorrentRenamePathArgs args,
      {RpcTag? tag,
      int? timeout}) {
    final p = TorrentRenamePathRequestParam.build(
        args: args, version: serverRpcVersion);
    preCheck(TransmissionRpcMethod.torrentRenamePath, p, timeout: timeout);
    return _torrentRenamePath(p, tag: tag, timeout: timeout);
  }

  Future<TorrentRenamePathResponse> _torrentRenamePath(
      TorrentRenamePathRequestParam p,
      {required RpcTag? tag,
      required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentRenamePath, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentRenamePathResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }
}

extension TransmissionRpcTorrentExtention on TransmissionRpcClient {
  // Get torrents info
  Future<TorrentGetResponse> torrentGetAll(TorrentIds ids,
      {RpcTag? tag, int? timeout}) {
    final p = TorrentGetRequestParam.build(
        version: serverRpcVersion, ids: ids, fields: null);
    preCheck(TransmissionRpcMethod.torrentGet, p, timeout: timeout);
    return _torrentGetAll(p, tag: tag, timeout: timeout);
  }

  Future<TorrentGetResponse> _torrentGetAll(TorrentGetRequestParam p,
      {required RpcTag? tag, required int? timeout}) async {
    final request = TransmissionRpcRequest(
        param: p, method: TransmissionRpcMethod.torrentGet, tag: tag);
    final rawData = await doRequest(request, timeout: timeout);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final result = rawResult.toString();
    return TransmissionRpcResponse(
      request: request,
      result: result,
      param: TransmissionRpcResponse.isSucceed(result) && rawParam is JsonMap
          ? TorrentGetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }
}
