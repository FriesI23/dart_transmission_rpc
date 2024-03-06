// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_transmission_rpc/src/request.dart';
import 'package:flutter_transmission_rpc/src/response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockedRpcRequest extends Mock implements TransmissionRpcRequest {
  final String? mockedKey;

  MockedRpcRequest({this.mockedKey});
}

class MockedResponseParam extends Mock implements ResponseParam {
  final String? mockedKey;

  MockedResponseParam({this.mockedKey});
}

void testTransmissionRpcResponse() => group("test TransmissionRpcResponse", () {
      group("factory constructor: ()", () {
        test("default", () {
          final r = TransmissionRpcResponse(
              request: MockedRpcRequest(mockedKey: "keyy"), result: "test");
          expect(r.runtimeType.toString(),
              startsWith("_TransmissionRpcResponse<"));
          expect(r.runtimeType.toString(),
              contains("<ResponseParam, MockedRpcRequest>"));
          expect(r.request.mockedKey, "keyy");
          expect(r.result, "test");
          expect(r.param, isNull);
          expect(r.tag, isNull);
        });
        test("with args", () {
          final r = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "rkey"),
            result: "test",
            param: MockedResponseParam(mockedKey: "pkey"),
            tag: 1234,
          );
          expect(r.runtimeType.toString(),
              startsWith("_TransmissionRpcResponse<"));
          expect(r.runtimeType.toString(),
              contains("<MockedResponseParam, MockedRpcRequest>"));
          expect(r.request.mockedKey, "rkey");
          expect(r.result, "test");
          expect(r.param, isNotNull);
          expect(r.param!.mockedKey, "pkey");
          expect(r.tag, 1234);
        });
      });
      group("static method: parseResult", () {
        test("is string", () {
          final jsonData = {TransmissionRpcResponseKey.result.keyName: "test"};
          final r = TransmissionRpcResponse.parseResult(jsonData);
          expect(r, "test");
        });
        test("is null", () {
          final jsonData = {TransmissionRpcResponseKey.result.keyName: null};
          final r = TransmissionRpcResponse.parseResult(jsonData);
          expect(r, TransmissionRpcResponse.unknownResult);
        });
        test("is anything else", () {
          final jsonData = {
            TransmissionRpcResponseKey.result.keyName: ["success"],
            "foo": "bar",
          };
          final r = TransmissionRpcResponse.parseResult(jsonData);
          expect(r, TransmissionRpcResponse.unknownResult);
        });
        test("missing key", () {
          expect(TransmissionRpcResponse.parseResult({}),
              TransmissionRpcResponse.unknownResult);
        });
      });
      group("static method: parseTag", () {
        test("is RpcTag", () {
          final jsonData = {TransmissionRpcResponseKey.tag.keyName: 123};
          final r = TransmissionRpcResponse.parseTag(jsonData);
          expect(r, 123);
        });
        test("is null", () {
          final jsonData = {TransmissionRpcResponseKey.tag.keyName: null};
          final r = TransmissionRpcResponse.parseTag(jsonData);
          expect(r, isNull);
        });
        test("is anything else", () {
          final jsonData = {
            TransmissionRpcResponseKey.tag.keyName: [123],
            "foo": "bar",
          };
          final r = TransmissionRpcResponse.parseTag(jsonData);
          expect(r, isNull);
        });
        test("missing key", () {
          final r = TransmissionRpcResponse.parseTag({});
          expect(r, isNull);
        });
      });
      group("static method: parseArguments", () {
        test("is JsonMap", () {
          final jsonData = {
            TransmissionRpcResponseKey.arguments.keyName: {"foo": "bar"}
          };
          final r = TransmissionRpcResponse.parseArguments(jsonData);
          expect(r, {"foo": "bar"});
        });
        test("is null", () {
          final jsonData = {TransmissionRpcResponseKey.arguments.keyName: null};
          final r = TransmissionRpcResponse.parseArguments(jsonData);
          expect(r, isNull);
        });
        test("is anything else", () {
          final jsonData = {
            TransmissionRpcResponseKey.arguments.keyName: [123],
            "foo": "bar",
          };
          final r = TransmissionRpcResponse.parseArguments(jsonData);
          expect(r, isNull);
        });
        test("missing key", () {
          final r = TransmissionRpcResponse.parseArguments({});
          expect(r, isNull);
        });
      });
    });

void testTransmissionRpcResponseImp() =>
    group("test _TransmissionRpcResponse", () {
      group("method: isOk", () {
        test("succ with default", () {
          final r = TransmissionRpcResponse(
              request: MockedRpcRequest(mockedKey: "keyy"), result: "success");
          expect(r.isOk(), true);
        });
        test("succ with args", () {
          final r1 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "keyy"),
            param: MockedResponseParam(),
            result: "success",
          );
          expect(r1.isOk(), true);
          final r2 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "keyy"),
            tag: 1234,
            result: "success",
          );
          expect(r2.isOk(), true);
          final r3 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "keyy"),
            param: MockedResponseParam(),
            tag: 1234,
            result: "success",
          );
          expect(r3.isOk(), true);
        });
        test("fail with default", () {
          final r1 = TransmissionRpcResponse(
              request: MockedRpcRequest(mockedKey: "key"), result: "succ");
          expect(r1.isOk(), false);
          final r2 = TransmissionRpcResponse(
              request: MockedRpcRequest(mockedKey: "key"), result: "");
          expect(r2.isOk(), false);
          final r3 = TransmissionRpcResponse(
              request: MockedRpcRequest(mockedKey: "key"), result: "successed");
          expect(r3.isOk(), false);
        });
        test("fail with args", () {
          final r1 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "key"),
            param: MockedResponseParam(),
            result: "succ",
          );
          expect(r1.isOk(), false);
          final r2 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "key"),
            tag: 1234,
            result: "",
          );
          expect(r2.isOk(), false);
          final r3 = TransmissionRpcResponse(
            request: MockedRpcRequest(mockedKey: "key"),
            param: MockedResponseParam(),
            tag: 1234,
            result: "successed",
          );
          expect(r3.isOk(), false);
        });
      });
    });

void main() {
  testTransmissionRpcResponse();
  testTransmissionRpcResponseImp();
}
