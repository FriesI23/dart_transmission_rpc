// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'method.dart';
import 'typedef.dart';

abstract interface class RequestParam {
  String? check();
  JsonMap toRpcJson();
}

enum TransmissionRpcRequestJsonKey {
  arguments(keyName: "arguments"),
  method(keyName: "method"),
  tag(keyName: "tag");

  final String keyName;

  const TransmissionRpcRequestJsonKey({required this.keyName});
}

abstract interface class TransmissionRpcRequest<T extends RequestParam> {
  TransmissionRpcMethod get method;
  T? get param;
  RpcTag? get tag;

  JsonMap toRpcJson();

  factory TransmissionRpcRequest({
    required TransmissionRpcMethod method,
    T? param,
    RpcTag? tag,
  }) =>
      _TransmissionRpcRequest(
        method: method,
        param: param,
        tag: tag,
      );
}

class _TransmissionRpcRequest<T extends RequestParam>
    implements TransmissionRpcRequest<T> {
  @override
  final TransmissionRpcMethod method;
  @override
  final T? param;
  @override
  final RpcTag? tag;

  const _TransmissionRpcRequest({
    required this.method,
    this.param,
    this.tag,
  });

  @override
  JsonMap toRpcJson() => {
        TransmissionRpcRequestJsonKey.method.keyName: method.methodName,
        if (param != null)
          TransmissionRpcRequestJsonKey.arguments.keyName: param!.toRpcJson(),
        if (tag != null) TransmissionRpcRequestJsonKey.tag.keyName: tag,
      };
}
