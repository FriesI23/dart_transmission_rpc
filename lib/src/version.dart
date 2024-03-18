// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

const kMinimumSupportRpcVersion = 14;

class ServerRpcVersion {
  /// Current rpc version supported
  final num rpcVersion;

  /// The minimum rpc version supported
  final num minRpcVersion;

  /// Last server rpc version update time
  final DateTime updateDate;

  const ServerRpcVersion({
    required this.rpcVersion,
    required this.minRpcVersion,
    required this.updateDate,
  }) : assert(rpcVersion >= minRpcVersion);

  ServerRpcVersion.build(this.rpcVersion, this.minRpcVersion)
      : updateDate = DateTime.now().toUtc(),
        assert(rpcVersion >= minRpcVersion);

  bool isValidateServerVersion() =>
      rpcVersion >= kMinimumSupportRpcVersion &&
      rpcVersion > 0 &&
      minRpcVersion > 0;

  bool checkApiVersionValidate({num? v}) {
    final vv = v ?? kMinimumSupportRpcVersion;
    return vv >= minRpcVersion && vv <= rpcVersion;
  }

  @override
  String toString() => "Version {v: $rpcVersion, mv: $minRpcVersion}";
}
