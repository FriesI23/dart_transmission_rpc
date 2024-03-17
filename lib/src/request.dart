// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'method.dart';
import 'typedef.dart';

abstract interface class RequestParam {
  static String? buildCheckResult(
      Iterable<RequestParamCheckResult> checkResults) {
    final stringResults = checkResults
        .where((e) => !e.isOk)
        .map((e) => e.checkResultStr)
        .toList();
    return stringResults.isNotEmpty
        ? "got possibly imcompatible fields, ${stringResults.join(", ")}"
        : null;
  }

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

abstract interface class RequestParamChecker<T> {
  RequestParamCheckResult<T> check();
}

class RequestParamCheckResult<T> {
  final String label;
  final Set<T> checkFailedFields;

  const RequestParamCheckResult({
    required this.label,
    this.checkFailedFields = const {},
  });

  bool get isOk => checkFailedFields.isEmpty;

  String? get checkResultStr => !isOk ? "$label: $checkFailedFields" : null;
}

class RequestParamArgsChecker<T> implements RequestParamChecker {
  final String label;
  final Iterable<T> _fields;
  final bool Function(T f)? failedChecker;

  RequestParamArgsChecker({
    this.label = "unknown",
    required Iterable<T> fields,
    this.failedChecker,
  }) : _fields = fields;

  bool _defaultChecker(T f) => false;

  @override
  RequestParamCheckResult<T> check() {
    final Set<T> fields = {};
    for (var f in _fields) {
      if ((failedChecker ?? _defaultChecker)(f)) fields.add(f);
    }
    return RequestParamCheckResult(checkFailedFields: fields, label: label);
  }

  RequestParamArgsChecker<T> copyWith({
    Set<T>? fields,
    bool Function(T f)? failedChecker,
  }) {
    return RequestParamArgsChecker<T>(
        fields: fields ?? _fields,
        failedChecker: failedChecker ?? this.failedChecker);
  }
}
