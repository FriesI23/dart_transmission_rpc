// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:dart_transmission_rpc/src/exception.dart';
import 'package:test/test.dart';

void testTransmissionError() => group("test TransmissionError", () {
      test("exp: TransmissionError", () {
        const e = TransmissionError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TransmissionError: test"));
      });
      test("exp: TransmissionAuthError", () {
        const e = TransmissionAuthError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TransmissionAuthError: test"));
      });
      test("exp: TranmissionConnectionError", () {
        const e = TranmissionConnectionError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TranmissionConnectionError: test"));
      });
      test("exp: TransmissionTimeoutError", () {
        const e = TransmissionTimeoutError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TransmissionTimeoutError: test"));
      });
      test("exp: TranmissionMaxRetryRequestError", () {
        const e = TranmissionMaxRetryRequestError("test", 10);
        expect(e.reason, equals("test"));
        expect(e.retryCount, equals(10));
        expect(e.toString(),
            equals("TranmissionMaxRetryRequestError: test, for 10 times"));
      });
      test("exp: TransmissionRpcDataError", () {
        const e = TransmissionRpcDataError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TransmissionRpcDataError: test"));
      });
      test("exp: TransmissionCheckError", () {
        const e = TransmissionCheckError("test");
        expect(e.reason, equals("test"));
        expect(e.toString(), equals("TransmissionCheckError: test"));
      });
      test("exp: TransmissionVersionError", () {
        const e = TransmissionVersionError("test", 10, 8);
        expect(e.reason, equals("test"));
        expect(e.serverRpcVersion, equals(10));
        expect(e.serverRpcVersionMinimum, equals(8));
        expect(e.toString(),
            equals("TransmissionVersionError: test, version=[8,10]"));
      });
    });

void main() {
  testTransmissionError();
}
