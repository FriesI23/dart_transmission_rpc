// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:dart_transmission_rpc/src/method.dart';
import 'package:dart_transmission_rpc/src/request.dart';
import 'package:dart_transmission_rpc/src/typedef.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockedRequestParam extends Mock implements RequestParam {
  final JsonMap? expectToRpcJsonData;

  MockedRequestParam({this.expectToRpcJsonData});

  @override
  JsonMap toRpcJson() => expectToRpcJsonData ?? {};
}

void testTransmissionRpcRequest() => group("test TransmissionRpcRequest", () {
      group("factory constructor: ()", () {
        test("default", () {
          final r =
              TransmissionRpcRequest(method: TransmissionRpcMethod.sessionGet);
          expect(
              r.runtimeType.toString(), startsWith("_TransmissionRpcRequest<"));
          expect(r.runtimeType.toString(), contains("<RequestParam>"));
          expect(r.method, TransmissionRpcMethod.sessionGet);
          expect(r.param, isNull);
          expect(r.tag, isNull);
        });
        test("with param and tag", () {
          final r = TransmissionRpcRequest(
            method: TransmissionRpcMethod.sessionGet,
            param: MockedRequestParam(),
            tag: 123,
          );
          expect(
              r.runtimeType.toString(), startsWith("_TransmissionRpcRequest<"));
          expect(r.runtimeType.toString(), contains("<MockedRequestParam>"));
          expect(r.method, TransmissionRpcMethod.sessionGet);
          expect(r.param, isNotNull);
          expect(r.param is RequestParam, true);
          expect(r.tag, equals(123));
        });
      });
    });

void testTransmissionRpcRequestImp() =>
    group("test _TransmissionRpcRequest", () {
      group("method: toRpcJson", () {
        test("with default args", () {
          final r =
              TransmissionRpcRequest(method: TransmissionRpcMethod.sessionGet);
          final jsonData = r.toRpcJson();
          expect(jsonData, {
            TransmissionRpcRequestJsonKey.method.keyName:
                TransmissionRpcMethod.sessionGet.methodName
          });
        });
        test("with param and tag", () {
          final expectParamJsonData = {"foo": "bar"};
          final r = TransmissionRpcRequest(
            method: TransmissionRpcMethod.sessionGet,
            param: MockedRequestParam(expectToRpcJsonData: expectParamJsonData),
            tag: 123,
          );
          final jsonData = r.toRpcJson();
          expect(jsonData, {
            TransmissionRpcRequestJsonKey.method.keyName:
                TransmissionRpcMethod.sessionGet.methodName,
            TransmissionRpcRequestJsonKey.arguments.keyName:
                Map.of(expectParamJsonData),
            TransmissionRpcRequestJsonKey.tag.keyName: 123,
          });
        });
      });
    });

void main() {
  testTransmissionRpcRequest();
  testTransmissionRpcRequestImp();
}
