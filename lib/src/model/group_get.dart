// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';
import '../utils.dart';
import '../version.dart';

enum GroupGetArgument {
  group(argName: "group"),
  name(argName: "name"),
  honorSessionLimits(argName: "honorsSessionLimits"),
  speedLimitDownEnabled(argName: "speed-limit-down-enabled"),
  speedLimitDown(argName: "speed-limit-down"),
  speedLimitUpEnabled(argName: "speed-limit-up-enabled"),
  speedLimitUp(argName: "speed-limit-up");

  final String argName;

  const GroupGetArgument({required this.argName});
}

abstract class GroupGetRequestParam implements RequestParam {
  final List<String>? group;

  const GroupGetRequestParam(this.group);

  static final _verionBuilderMap =
      <ParamBuilderEntry1<GroupGetRequestParam, List<String>?>>[
    MapEntry(17, (group) => _GroupGetRequestParamRpc17(group)),
  ];

  factory GroupGetRequestParam.build(
          {required ServerRpcVersion? version, required List<String>? group}) =>
      buildRequestParam1(version, group,
          nullVersionBuilder: (group) => const _GroupGetRequestParam(),
          defaultVersionBuilder: (group) => const _GroupGetRequestParam(),
          versionBuilers: _verionBuilderMap);
}

class _GroupGetRequestParam extends GroupGetRequestParam {
  const _GroupGetRequestParam() : super(const []);

  @override
  String? check() => "group-get need rpc version >= 17";

  @override
  JsonMap toRpcJson() => {};
}

class _GroupGetRequestParamRpc17 extends GroupGetRequestParam {
  const _GroupGetRequestParamRpc17(super.group);

  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {
        if (group != null) GroupGetArgument.group.argName: group,
      };
}

class GroupGetResponseParam implements ResponseParam {
  final List<GroupDesc> group;

  const GroupGetResponseParam({required this.group});

  factory GroupGetResponseParam.fromJson(JsonMap rawData) {
    final rawGroup = rawData[GroupGetArgument.group.argName];
    final group = (rawGroup is List ? rawGroup : [])
        .whereType<JsonMap>()
        .map((e) => GroupDesc.fromJson(e))
        .toList();
    return GroupGetResponseParam(group: group);
  }
}

class GroupDesc {
  /// Bandwidth group name
  final String name;

  /// true if session upload limits are honored
  final bool honorsSessionLimits;

  /// true means enabled
  final bool speedLimitDownEnabled;

  /// max global download speed (KBps)
  final num speedLimitDown;

  /// true means enabled
  final bool speedLimitUpEnabled;

  /// max global upload speed (KBps)
  final num speedLimitUp;

  const GroupDesc({
    required this.name,
    required this.honorsSessionLimits,
    required this.speedLimitDownEnabled,
    required this.speedLimitDown,
    required this.speedLimitUpEnabled,
    required this.speedLimitUp,
  });

  factory GroupDesc.fromJson(JsonMap rawData) {
    return GroupDesc(
      name: rawData[GroupGetArgument.name.argName] as String,
      honorsSessionLimits:
          rawData[GroupGetArgument.honorSessionLimits.argName] as bool,
      speedLimitDownEnabled:
          rawData[GroupGetArgument.speedLimitDownEnabled.argName] as bool,
      speedLimitDown: rawData[GroupGetArgument.speedLimitDown.argName] as num,
      speedLimitUpEnabled:
          rawData[GroupGetArgument.speedLimitUpEnabled.argName] as bool,
      speedLimitUp: rawData[GroupGetArgument.speedLimitUp.argName] as num,
    );
  }

  @override
  String toString() {
    return 'GroupDesc {name: $name, honorsSessionLimits: $honorsSessionLimits, '
        'speedLimitDownEnabled: $speedLimitDownEnabled, '
        'speedLimitDown: $speedLimitDown, '
        'speedLimitUpEnabled: $speedLimitUpEnabled, '
        'speedLimitUp: $speedLimitUp}';
  }
}
