// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import "../exception.dart";
import "../request.dart";
import "../response.dart";
import "../typedef.dart";
import "../utils.dart";
import "../version.dart";

enum GroupSetArgument {
  /// Bandwidth group name
  name(argName: "name"),

  /// true if session upload limits are honored
  honorSessionLimits(argName: "honorsSessionLimits"),

  /// true to enable group's global download speed limit
  speedLimitDownEnabled(argName: "speed-limit-down-enabled"),

  /// max global download speed (KBps)
  speedLimitDown(argName: "speed-limit-down"),

  /// true to enable group's global upload speed limit
  speedLimitUpEnabled(argName: "speed-limit-up-enabled"),

  /// max global upload speed (KBps)
  speedLimitUp(argName: "speed-limit-up");

  final String argName;

  const GroupSetArgument({required this.argName});
}

mixin GroupSetRequestArgsDefine {
  String get name;
  bool? get honorSessionLimits;
  bool? get speedLimitDownEnabled;
  num? get speedLimitDown;
  bool? get speedLimitUpEnabled;
  num? get speedLimitUp;
}

class GroupSetRequestArgs with GroupSetRequestArgsDefine {
  @override
  final String name;
  @override
  final bool? honorSessionLimits;
  @override
  final bool? speedLimitDownEnabled;
  @override
  final num? speedLimitDown;
  @override
  final bool? speedLimitUpEnabled;
  @override
  final num? speedLimitUp;

  const GroupSetRequestArgs({
    required this.name,
    this.honorSessionLimits,
    this.speedLimitDownEnabled,
    this.speedLimitDown,
    this.speedLimitUpEnabled,
    this.speedLimitUp,
  });
}

abstract class GroupSetRequestParam
    with GroupSetRequestArgsDefine
    implements RequestParam {
  final GroupSetRequestArgs _args;

  @override
  String get name => _args.name;

  @override
  bool? get honorSessionLimits => _args.honorSessionLimits;

  @override
  bool? get speedLimitDownEnabled => _args.speedLimitDownEnabled;

  @override
  num? get speedLimitDown => _args.speedLimitDown;

  @override
  bool? get speedLimitUpEnabled => _args.speedLimitUpEnabled;

  @override
  num? get speedLimitUp => _args.speedLimitUp;

  const GroupSetRequestParam({required GroupSetRequestArgs args})
      : _args = args;

  static final _verionBuilderMap =
      <ParamBuilderEntry1<GroupSetRequestParam, GroupSetRequestArgs>>[
    MapEntry(17, (args) => _GroupSetRequestParamRpc17(args)),
  ];

  factory GroupSetRequestParam.build({
    required ServerRpcVersion? version,
    required GroupSetRequestArgs args,
  }) =>
      buildRequestParam1(version, args,
          nullVersionBuilder: (args) => const _GroupSetRequestParam(),
          defaultVersionBuilder: (args) => const _GroupSetRequestParam(),
          versionBuilers: _verionBuilderMap);
}

class _GroupSetRequestParam extends GroupSetRequestParam {
  const _GroupSetRequestParam()
      : super(args: const GroupSetRequestArgs(name: ""));

  @override
  String? check() => "group-set need rpc version >= 17";

  @override
  JsonMap toRpcJson() => {};
}

class _GroupSetRequestParamRpc17 extends GroupSetRequestParam {
  const _GroupSetRequestParamRpc17(GroupSetRequestArgs args)
      : super(args: args);

  @override
  String? check() {
    if (name.isEmpty) {
      throw const TransmissionCheckError("must set name");
    }
    return null;
  }

  @override
  JsonMap toRpcJson() => {
        GroupSetArgument.name.argName: name,
        if (honorSessionLimits != null)
          GroupSetArgument.honorSessionLimits.argName: honorSessionLimits,
        if (speedLimitDownEnabled != null)
          GroupSetArgument.speedLimitDownEnabled.argName: speedLimitDownEnabled,
        if (speedLimitDown != null)
          GroupSetArgument.speedLimitDown.argName: speedLimitDown,
        if (speedLimitUpEnabled != null)
          GroupSetArgument.speedLimitUpEnabled.argName: speedLimitUpEnabled,
        if (speedLimitUp != null)
          GroupSetArgument.speedLimitUp.argName: speedLimitUp,
      };
}

class GroupSetResponseParam implements ResponseParam {
  const GroupSetResponseParam();

  factory GroupSetResponseParam.fromJson(JsonMap rawData) =>
      const GroupSetResponseParam();
}
