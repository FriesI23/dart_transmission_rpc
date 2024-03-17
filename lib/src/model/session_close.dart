// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import '../request.dart';
import '../response.dart';
import '../typedef.dart';

class SessionCloseRequestParam implements RequestParam {
  @override
  String? check() => null;

  @override
  JsonMap toRpcJson() => {};
}

class SessionCloseResponseParam implements ResponseParam {
  const SessionCloseResponseParam();

  factory SessionCloseResponseParam.fromJson(JsonMap rawData) =>
      const SessionCloseResponseParam();
}
