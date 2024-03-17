// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_transmission_rpc/src/version.dart';
import 'package:test/test.dart';

void testServerRpcVersion() => group("test ServerRpcVersion", () {
      group("constructor: ()", () {
        test("normal", () {
          final date = DateTime.now().toUtc();
          final v = ServerRpcVersion(
              rpcVersion: 10, minRpcVersion: 8, updateDate: date);
          expect(v.rpcVersion, equals(10));
          expect(v.minRpcVersion, equals(8));
          expect(v.updateDate, equals(date));
        });
        test("min rpc verion > rpc version", () {
          final date = DateTime.now().toUtc();
          expect(
              () => ServerRpcVersion(
                  rpcVersion: 7, minRpcVersion: 8, updateDate: date),
              throwsA(predicate((e) => e is AssertionError)));
        });
      });
      group("named constructor: build", () {
        test("normal", () {
          final v = ServerRpcVersion.build(10, 8);
          expect(v.rpcVersion, equals(10));
          expect(v.minRpcVersion, equals(8));
          expect(v.updateDate.runtimeType, equals(DateTime));
        });
        test("min rpc verion > rpc version", () {
          expect(() => ServerRpcVersion.build(7, 8),
              throwsA(predicate((e) => e is AssertionError)));
        });
      });
      group("method: isValidateServerVersion", () {
        test("valid case 1", () {
          final v = ServerRpcVersion.build(
              kMinimumSupportRpcVersion + 1, kMinimumSupportRpcVersion);
          expect(v.isValidateServerVersion(), true);
        });
        test("valid case 2", () {
          final v = ServerRpcVersion.build(
              kMinimumSupportRpcVersion, kMinimumSupportRpcVersion);
          expect(v.isValidateServerVersion(), true);
        });
        test("invalid case 1", () {
          final v = ServerRpcVersion.build(
              kMinimumSupportRpcVersion - 1, kMinimumSupportRpcVersion - 1);
          expect(v.isValidateServerVersion(), false);
        });
        test("invalid case 2", () {
          final v = ServerRpcVersion.build(
              kMinimumSupportRpcVersion - 1, kMinimumSupportRpcVersion - 2);
          expect(v.isValidateServerVersion(), false);
        });
      });
      group("method: checkApiVersionValidate", () {
        test("valid case: no version arg", () {
          expect(
              ServerRpcVersion.build(kMinimumSupportRpcVersion + 1,
                      kMinimumSupportRpcVersion - 1)
                  .checkApiVersionValidate(),
              true);
          expect(
              ServerRpcVersion.build(
                      kMinimumSupportRpcVersion, kMinimumSupportRpcVersion - 1)
                  .checkApiVersionValidate(),
              true);
          expect(
              ServerRpcVersion.build(
                      kMinimumSupportRpcVersion, kMinimumSupportRpcVersion)
                  .checkApiVersionValidate(),
              true);
        });
        test("invalid case: no version arg", () {
          // version smaller than minRpcVersion
          expect(
              ServerRpcVersion.build(kMinimumSupportRpcVersion + 1,
                      kMinimumSupportRpcVersion + 1)
                  .checkApiVersionValidate(),
              false);
          // version larger than server rpc version
          expect(
              ServerRpcVersion.build(kMinimumSupportRpcVersion - 1,
                      kMinimumSupportRpcVersion - 1)
                  .checkApiVersionValidate(),
              false);
        });
        final rpcVersion = ServerRpcVersion.build(17, 12);
        test("valid case: minRpcVersion <= v <= rpcVersion", () {
          for (var i = 12; i <= 17; i++) {
            expect(rpcVersion.checkApiVersionValidate(v: i), true);
          }
        });
      });
    });

void main() {
  testServerRpcVersion();
}
