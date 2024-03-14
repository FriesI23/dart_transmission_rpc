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
import 'model/port_test.dart';
import 'model/queue_move.dart';
import 'model/session_get.dart';
import 'model/session_set.dart';
import 'model/session_stats.dart';
import 'model/torrent.dart';
import 'request.dart';
import 'response.dart';
import 'typedef.dart';
import 'utils.dart';
import 'version.dart';

// session-get
typedef SessionGetResponse = TransmissionRpcResponse<SessionGetResponseParam,
    TransmissionRpcRequest<SessionGetRequestParam>>;
// session-set
typedef SessionSetResponse = TransmissionRpcResponse<SessionSetResponseParam,
    TransmissionRpcRequest<SessionSetRequestParam>>;
// session-stats
typedef SessionStatsResponse = TransmissionRpcResponse<
    SessionStatsResponseParam,
    TransmissionRpcRequest<SessionStatsRequestParam>>;
// blocklist-update
typedef BlocklistUpdateResponse = TransmissionRpcResponse<
    BlocklistUpdateResponseParam,
    TransmissionRpcRequest<BlocklistUpdateRequestParam>>;
// port-test
typedef PortTestResponse = TransmissionRpcResponse<PortTestResponseParam,
    TransmissionRpcRequest<PortTestReqeustParam>>;
// queue-move-*
typedef QueueMoveResponse<T extends QueueMoveRequestParam>
    = TransmissionRpcResponse<QueueMoveResponseParam,
        TransmissionRpcRequest<T>>;
// free-space
typedef FreeSpaceResponse = TransmissionRpcResponse<FreeSpaceResponseParam,
    TransmissionRpcRequest<FreeSpaceRequestParam>>;

enum TransmissionRpcRetryReason { csrf }

abstract interface class TransmissionRpcClient {
  Uri get url;
  String? get username;
  String? get password;
  ServerRpcVersion? get serverRpcVersion;
  int get maxRetryCount;
  int get timeout;

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

  Future<void> init();
  bool isInited();
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
    final response = await _sessionGet(
        SessionGetRequestParam.build(fields: const [
          SessionGetArgument.rpcVersion,
          SessionGetArgument.rpcVersionMinimum,
        ]),
        tag: null,
        timeout: null);
    if (!response.isOk() ||
        response.param?.rpcVersion == null ||
        response.param?.rpcVersionMinimum == null) {
      throw TransmissionError("init client failed, reason: ${response.result}");
    }
    _serverRpcVersion = ServerRpcVersion.build(
      response.param!.rpcVersion!,
      response.param!.rpcVersionMinimum!,
    );
    if (!_serverRpcVersion.isValidateServerVersion()) {
      throw TransmissionVersionError("init server check failed",
          _serverRpcVersion.rpcVersion, _serverRpcVersion.minRpcVersion);
    }
    // init completed
    _inited = true;
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
    final resultText =
        await _doRequest(body, Duration(milliseconds: timeout ?? this.timeout));
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
        return _doRequest(body, timeout,
            usedTime: newUseTime,
            retryCount: newRetryCount,
            retryReasonList: retryReasonList);
    }

    return httpResponse.transform(utf8.decoder).join();
  }

  void preCheck(TransmissionRpcMethod method, RequestParam? p,
      {required int? timeout}) {
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
    final request = TransmissionRpcRequest<PortTestReqeustParam>(
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
}
