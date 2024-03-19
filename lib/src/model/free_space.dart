// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';

enum FreeSpaceArgument {
  /// the directory to query
  path(argName: "path"),

  /// the size, in bytes, of the free space in that directory
  sizeBytes(argName: "size-bytes"),

  /// the total capacity, in bytes, of that directory
  totalSize(argName: "total_size");

  final String argName;

  const FreeSpaceArgument({required this.argName});
}

abstract class FreeSpaceRequestParam implements RequestParam {
  final String path;

  const FreeSpaceRequestParam(this.path);

  static final _verionBuilderMap =
      <ParamBuilderEntry1<FreeSpaceRequestParam, String>>[
    MapEntry(15, (path) => _FreeSpaceRequstParamRpc15(path)),
  ];

  factory FreeSpaceRequestParam.build(
          {required ServerRpcVersion? version, required String path}) =>
      buildRequestParam1(version, path,
          nullVersionBuilder: (path) => const _FreeSpaceRequestParam(),
          defaultVersionBuilder: (path) => const _FreeSpaceRequestParam(),
          versionBuilers: _verionBuilderMap);
}

class _FreeSpaceRequestParam extends FreeSpaceRequestParam {
  const _FreeSpaceRequestParam() : super("");

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
  /// the directory to query, same as the Request argument
  final String path;

  /// the size, in bytes, of the free space in that directory
  final num sizeBytes;

  /// the total capacity, in bytes, of that directory
  final num? totalSize;

  const FreeSpaceResponseParam({
    required this.path,
    required this.sizeBytes,
    this.totalSize,
  });

  static final _verionBuilderMap =
      <ParamBuilderEntry1<FreeSpaceResponseParam, JsonMap>>[
    MapEntry(17, (rawData) => _FreeSpaceResponseParamRpc17.fromJson(rawData)),
  ];

  factory FreeSpaceResponseParam.fromJson(JsonMap rawData,
          {required ServerRpcVersion? v}) =>
      buildResponseParam1(v, rawData,
          nullVersionBuilder: (rawData) =>
              _FreeSpaceResponseParam.fromJson(rawData),
          defaultVersionBuilder: (rawData) =>
              _FreeSpaceResponseParam.fromJson(rawData),
          versionBuilers: _verionBuilderMap);
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
