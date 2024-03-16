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

abstract interface class RequestParamChecker<T> {
  RequestParamCheckResult<T> check();
}

class RequestParamCheckResult<T> {
  final Set<T> checkNotAllowedFields;
  final Set<T> checkDeprecatedFields;

  const RequestParamCheckResult({
    this.checkNotAllowedFields = const {},
    this.checkDeprecatedFields = const {},
  });

  List<String> get checkResult {
    String? notAllowedFieldsCheckResult() => checkNotAllowedFields.isNotEmpty
        ? "missing: $checkNotAllowedFields"
        : null;

    String? deprecatedFieldsCheckResult() => checkDeprecatedFields.isNotEmpty
        ? "deprecated: $checkDeprecatedFields"
        : null;

    final nr = notAllowedFieldsCheckResult();
    final dr = deprecatedFieldsCheckResult();
    return [
      if (nr != null) nr,
      if (dr != null) dr,
    ];
  }
}

class RequestParamArgsChecker<T> implements RequestParamChecker {
  final Set<T> _notAllowedFields;
  final Set<T> _deprecatedFields;
  final bool Function(T f)? checkNotAllowedFields;
  final bool Function(T f)? checkDeprecatedFields;

  RequestParamArgsChecker({
    required Set<T> notAllowedFields,
    required Set<T> deprecatedFields,
    this.checkNotAllowedFields,
    this.checkDeprecatedFields,
  })  : _notAllowedFields = notAllowedFields,
        _deprecatedFields = deprecatedFields;

  bool _defaultCheckField(T f) => false;

  @override
  RequestParamCheckResult<T> check() {
    final Set<T> mFields = {};
    for (var f in _notAllowedFields) {
      if ((checkNotAllowedFields ?? _defaultCheckField)(f)) mFields.add(f);
    }
    final Set<T> dFields = {};
    for (var f in _deprecatedFields) {
      if ((checkDeprecatedFields ?? _defaultCheckField)(f)) dFields.add(f);
    }
    return RequestParamCheckResult(
      checkNotAllowedFields: mFields,
      checkDeprecatedFields: dFields,
    );
  }

  RequestParamArgsChecker<T> copyWith({
    Set<T>? notAllowedFields,
    Set<T>? deprecatedFields,
    bool Function(T f)? checkNotAllowedFields,
    bool Function(T f)? checkDeprecatedFields,
  }) {
    return RequestParamArgsChecker<T>(
      notAllowedFields: notAllowedFields ?? _notAllowedFields,
      deprecatedFields: deprecatedFields ?? _deprecatedFields,
      checkNotAllowedFields:
          checkNotAllowedFields ?? this.checkNotAllowedFields,
      checkDeprecatedFields:
          checkDeprecatedFields ?? this.checkDeprecatedFields,
    );
  }
}
