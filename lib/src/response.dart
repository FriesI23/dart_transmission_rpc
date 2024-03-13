// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'request.dart';
import 'typedef.dart';

abstract interface class ResponseParam {}

enum TransmissionRpcResponseKey {
  result(keyName: "result"),
  arguments(keyName: "arguments"),
  tag(keyName: "tag");

  final String keyName;

  const TransmissionRpcResponseKey({required this.keyName});
}

abstract interface class TransmissionRpcResponse<T extends ResponseParam,
    V extends TransmissionRpcRequest> {
  static const unknownResult = "failed with unknown reason";
  static const successResult = "success";

  V get request;
  String get result;
  T? get param;
  RpcTag? get tag;

  bool isOk();

  factory TransmissionRpcResponse({
    required V request,
    required String result,
    T? param,
    RpcTag? tag,
  }) =>
      _TransmissionRpcResponse(
        request: request,
        result: result,
        param: param,
        tag: tag,
      );

  static String parseResult(JsonMap rawData) {
    final rawResult = rawData[TransmissionRpcResponseKey.result.keyName];
    final result = rawResult is String ? rawResult : unknownResult;
    return result;
  }

  static RpcTag? parseTag(JsonMap rawData) {
    final rawTag = rawData[TransmissionRpcResponseKey.tag.keyName];
    final tag = RpcTag.tryParse(rawTag.toString());
    return tag;
  }

  static JsonMap? parseArguments(JsonMap rawData) {
    final rawArguments = rawData[TransmissionRpcResponseKey.arguments.keyName];
    final arguments = rawArguments is JsonMap ? rawArguments : null;
    return arguments;
  }

  static bool isSucceed(String? result) =>
      result != null && result == successResult;
}

class _TransmissionRpcResponse<T extends ResponseParam,
    V extends TransmissionRpcRequest> implements TransmissionRpcResponse<T, V> {
  @override
  final V request;
  @override
  final String result;
  @override
  final T? param;
  @override
  final RpcTag? tag;

  const _TransmissionRpcResponse({
    required this.request,
    required this.result,
    this.param,
    this.tag,
  });

  @override
  bool isOk() => TransmissionRpcResponse.isSucceed(result);
}
