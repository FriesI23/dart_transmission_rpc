// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../exception.dart';
import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../version.dart';

enum FreeSpaceArgument {
  path(argName: "path"),
  sizeBytes(argName: "size-bytes"),
  totalSize(argName: "total_size");

  final String argName;

  const FreeSpaceArgument({required this.argName});
}

abstract class FreeSpaceRequestParam implements RequestParam {
  final String path;

  const FreeSpaceRequestParam(this.path);

  factory FreeSpaceRequestParam.build(
      {required ServerRpcVersion? version, required String path}) {
    if (version == null) {
      return _FreeSpaceRequestParam(path);
    } else if (version.checkApiVersionValidate(v: 15)) {
      return _FreeSpaceRequstParamRpc15(path);
    } else if (version.checkApiVersionValidate()) {
      return _FreeSpaceRequestParam(path);
    } else {
      throw TransmissionVersionError("Incompatible API version on free-space",
          version.rpcVersion, version.minRpcVersion);
    }
  }
}

class _FreeSpaceRequestParam extends FreeSpaceRequestParam {
  const _FreeSpaceRequestParam(super.path);

  @override
  String? check() => "free-space need rpc verion >= 15";

  @override
  JsonMap toRpcJson() => {};
}

class _FreeSpaceRequstParamRpc15 extends FreeSpaceRequestParam {
  const _FreeSpaceRequstParamRpc15(super.path);

  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {FreeSpaceArgument.path.argName: path};
}

abstract class FreeSpaceResponseParam implements ResponseParam {
  final String path;
  final num sizeBytes;
  final num? totalSize;

  const FreeSpaceResponseParam({
    required this.path,
    required this.sizeBytes,
    this.totalSize,
  });

  factory FreeSpaceResponseParam.fromJson(JsonMap rawData,
      {required ServerRpcVersion? v}) {
    if (v == null) {
      return _FreeSpaceResponseParam.fromJson(rawData);
    } else if (v.checkApiVersionValidate(v: 17)) {
      return _FreeSpaceResponseParamRpc17.fromJson(rawData);
    } else {
      return _FreeSpaceResponseParam.fromJson(rawData);
    }
  }
}

class _FreeSpaceResponseParam extends FreeSpaceResponseParam {
  const _FreeSpaceResponseParam({
    required super.path,
    required super.sizeBytes,
  });

  factory _FreeSpaceResponseParam.fromJson(JsonMap rawData) {
    return _FreeSpaceResponseParam(
      path: rawData[FreeSpaceArgument.path.argName] as String,
      sizeBytes: rawData[FreeSpaceArgument.sizeBytes.argName] as num,
    );
  }
}

class _FreeSpaceResponseParamRpc17 extends FreeSpaceResponseParam {
  final num _totalSize;

  @override
  num get totalSize => _totalSize;

  const _FreeSpaceResponseParamRpc17({
    required super.path,
    required super.sizeBytes,
    required num totalSize,
  }) : _totalSize = totalSize;

  factory _FreeSpaceResponseParamRpc17.fromJson(JsonMap rawData) {
    return _FreeSpaceResponseParamRpc17(
      path: rawData[FreeSpaceArgument.path.argName] as String,
      sizeBytes: rawData[FreeSpaceArgument.sizeBytes.argName] as num,
      totalSize: rawData[FreeSpaceArgument.totalSize.argName] as num,
    );
  }
}
