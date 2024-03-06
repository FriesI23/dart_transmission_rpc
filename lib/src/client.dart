// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'apis/session_get.dart';
import 'exception.dart';
import 'method.dart';
import 'request.dart';
import 'response.dart';
import 'typedef.dart';
import 'utils.dart';
import 'version.dart';

typedef SessionGetReponse = TransmissionRpcResponse<SessionGetResponseParam,
    TransmissionRpcRequest<SessionGetRequestParam>>;

enum TranmissionRpcRetryReason { csrf }

abstract interface class TransmissionRpcClient {
  Uri get url;
  String? get username;
  String? get password;
  ServerRpcVersion? get serverRpcVersion;

  // Get session running stats by given fields
  Future<SessionGetReponse> sessionGet(List<SessionGetArgument>? fields,
      {RpcTag? tag});

  Future<void> init();
  bool isInited();
  Future<JsonMap> doRequest(TransmissionRpcRequest request);

  factory TransmissionRpcClient({
    HttpProtocol protocol = HttpProtocol.http,
    String? username,
    String? password,
    String host = "127.0.0.1",
    int port = 9091,
    String path = "/transmission/rpc",
  }) =>
      _TransmissionRpcClient(
        protocol: protocol,
        username: username,
        password: password,
        host: host,
        port: port,
        path: path,
      );
}

class _TransmissionRpcClient implements TransmissionRpcClient {
  static const defaultCredentialRealm = "Transmission";
  static const defaultSessionId = "0";
  static const defaultTag = 1;
  static const sesionIdHeaderKey = "X-Transmission-Session-Id";

  final HttpClient _httpClient;
  final int _maxRetryCount;
  @override
  final Uri url;
  @override
  final String? username;
  @override
  final String? password;

  late final ServerRpcVersion _serverRpcVersion;

  RpcTag _crtTag = defaultTag;
  String _sessionId = defaultSessionId;
  bool _inited = false;

  _TransmissionRpcClient({
    required HttpProtocol protocol,
    this.username,
    this.password,
    required String host,
    required int port,
    required String path,
    int maxRetryCount = 10,
  })  : _httpClient = HttpClient(),
        _maxRetryCount = maxRetryCount,
        url = Uri(scheme: protocol.name, host: host, port: port, path: path) {
    _initHttpCredential();
  }

  void _initHttpCredential() {
    if (username != null || password != null) {
      final credentials =
          HttpClientBasicCredentials(username ?? '', password ?? '');
      _httpClient.addCredentials(url, defaultCredentialRealm, credentials);
    }
  }

  @override
  Future<void> init() async {
    final response =
        await _sessionGet(SessionGetRequestParam.build(fields: const [
      SessionGetArgument.rpcVersion,
      SessionGetArgument.rpcVersionMinimum,
    ]));
    if (!response.isOk() ||
        response.param?.rpcVersion == null ||
        response.param?.rpcVersionMinimum == null) {
      throw const TransmissionError("init client failed");
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

  void bumpTag() {
    if (_crtTag >= kMaxRpcTag) {
      _crtTag = defaultTag;
    } else {
      _crtTag += 1;
    }
  }

  RpcTag get currentTag => _crtTag;

  @override
  Future<JsonMap> doRequest(TransmissionRpcRequest request) async {
    final payload = jsonEncode(request.toRpcJson());
    final body = utf8.encode(payload);
    final resultText = await _doRequest(body);
    final rawText = jsonDecode(resultText);
    bumpTag();
    return rawText;
  }

  Future<String> _doRequest(
    Uint8List body, {
    int retryCount = 0,
    List<TranmissionRpcRetryReason>? retryReasonList,
  }) async {
    if (retryCount > _maxRetryCount) {
      throw TranmissionMaxRetryRequestError(
          "request retry count overlimit, $retryReasonList", retryCount);
    }

    final HttpClientResponse httpResponse;

    try {
      final httpRequest = await _httpClient.postUrl(url);
      httpRequest.headers.add(sesionIdHeaderKey, _sessionId);
      httpRequest.add(body);
      httpResponse = await httpRequest.close();
    } on HttpException catch (e) {
      throw TranmissionConnectionError(
          "can't connect to transmission server: ${e.toString()}");
    } on SocketException catch (e) {
      throw TranmissionConnectionError(
          "can't connect to transmission server: ${e.toString()}");
    } on TimeoutException catch (e) {
      throw TransmissionTimeoutError(
          "timeout when try connect to transmission server: ${e.toString()}");
    }

    _sessionId = httpResponse.headers.value(sesionIdHeaderKey) ?? _sessionId;

    final httpCode = httpResponse.statusCode;
    switch (httpCode) {
      case 401:
      case 403:
        throw TransmissionAuthError(
            "transmission server required auth, code: $httpCode");
      case 409:
        retryReasonList = retryReasonList ?? <TranmissionRpcRetryReason>[];
        retryReasonList.add(TranmissionRpcRetryReason.csrf);
        return _doRequest(body,
            retryCount: retryCount + 1, retryReasonList: retryReasonList);
    }

    return httpResponse.transform(utf8.decoder).join();
  }

  void preCheck(TransmissionRpcMethod method, RequestParam p) {
    if (!isInited()) {
      throw const TransmissionCheckError("Client has not been initialized.");
    }
    try {
      final reason = p.check();
      if (reason != null && reason.isNotEmpty) {
        // TODO: warning here.
      }
    } on TransmissionError catch (e) {
      throw TransmissionCheckError(
          "pre check failed, method: $method, reason: $e");
    }
  }

  @override
  Future<SessionGetReponse> sessionGet(List<SessionGetArgument>? fields,
      {RpcTag? tag}) {
    final p = SessionGetRequestParam.build(
      version: serverRpcVersion,
      fields: fields,
    );
    preCheck(TransmissionRpcMethod.sessionGet, p);
    return _sessionGet(p);
  }

  Future<SessionGetReponse> _sessionGet(SessionGetRequestParam p,
      {RpcTag? tag}) async {
    final request = TransmissionRpcRequest(
      method: TransmissionRpcMethod.sessionGet,
      param: p,
      tag: tag ?? _crtTag,
    );
    final rawData = await doRequest(request);
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final rawParam = rawData[TransmissionRpcRequestJsonKey.arguments.keyName];
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    return TransmissionRpcResponse(
      request: request,
      result: rawResult.toString(),
      param: rawParam is JsonMap
          ? SessionGetResponseParam.fromJson(rawParam)
          : null,
      tag: RpcTag.tryParse(rawTag.toString()),
    );
  }
}
