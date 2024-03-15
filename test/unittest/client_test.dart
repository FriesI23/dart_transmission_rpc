// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:io';

import 'package:flutter_transmission_rpc/src/model/session_get.dart';
import 'package:flutter_transmission_rpc/src/client.dart';
import 'package:flutter_transmission_rpc/src/exception.dart';
import 'package:flutter_transmission_rpc/src/response.dart';
import 'package:flutter_transmission_rpc/src/utils.dart';
import 'package:flutter_transmission_rpc/src/version.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  HttpClient,
  HttpClientRequest,
  HttpClientResponse,
  HttpHeaders,
])
import 'client_test.mocks.dart';

void testTransmissionRpcClient() => group("test TransmissionRpcClient", () {
      group("factory constructor: ()", () {
        test("default", () {
          final client = TransmissionRpcClient();
          expect(client.url.scheme, "http");
          expect(client.url.host, "127.0.0.1");
          expect(client.url.port, 9091);
          expect(client.url.path, "/transmission/rpc");
          expect(client.username, isNull);
          expect(client.password, isNull);
          expect(client.maxRetryCount, 10);
          expect(client.isInited(), false);
          expect(client.serverRpcVersion, isNull);
        });
        test("with custom args", () {
          final client = TransmissionRpcClient(
            protocol: HttpProtocol.https,
            username: "admin",
            password: "123456",
            host: "www.example.com",
            port: 9999,
            path: "custom/rpc",
            maxRetryCount: 1,
          );
          expect(client.url.scheme, "https");
          expect(client.url.host, "www.example.com");
          expect(client.url.port, 9999);
          expect(client.url.path, "/custom/rpc");
          expect(client.username, "admin");
          expect(client.password, "123456");
          expect(client.maxRetryCount, 1);
          expect(client.isInited(), false);
          expect(client.serverRpcVersion, isNull);
        });
        test("maxRetryCount oor", () {
          expect(
            () => TransmissionRpcClient(maxRetryCount: -1),
            throwsA(predicate((e) => e is AssertionError)),
          );
          expect(
            () => TransmissionRpcClient(maxRetryCount: 101),
            throwsA(predicate((e) => e is AssertionError)),
          );
        });
      });
    });

void testTransmissionRpcClientInit() =>
    group("test TransmissionRpcClient.init", () {
      MockHttpClient? httpClient;
      MockHttpClientRequest? httpRequest;
      MockHttpClientResponse? httpResponse;
      MockHttpHeaders httpHeaders = MockHttpHeaders();
      setUp(() {
        httpClient = MockHttpClient();
        httpRequest = MockHttpClientRequest();
        httpResponse = MockHttpClientResponse();
        when(httpClient!.postUrl(any)).thenAnswer((invo) {
          when(httpRequest!.uri).thenAnswer(
              (_) => Uri.dataFromString("http://localhost:90901/rpc"));
          when(httpRequest!.headers).thenReturn(httpHeaders);
          when(httpHeaders.value("X-Transmission-Session-Id")).thenReturn("0");
          when(httpRequest!.close())
              .thenAnswer((_) => Future.value(httpResponse));
          when(httpResponse!.headers).thenReturn(httpHeaders);
          when(httpResponse!.statusCode).thenReturn(200);
          return Future.value(httpRequest);
        });
      });
      test("normal", () {
        HttpOverrides.runZoned(
          () async {
            final body = jsonEncode({
              TransmissionRpcResponseKey.result.keyName: "success",
              TransmissionRpcResponseKey.arguments.keyName: {
                SessionGetArgument.rpcVersion.argName: 100,
                SessionGetArgument.rpcVersionMinimum.argName: 1,
              },
            });

            when(httpResponse!.transform(utf8.decoder)).thenAnswer((_) {
              return Stream.value(body);
            });

            final client = TransmissionRpcClient();
            await client.init();
            expect(client.isInited(), true);
            expect(client.serverRpcVersion!.rpcVersion, 100);
            expect(client.serverRpcVersion!.minRpcVersion, 1);
          },
          createHttpClient: (_) => httpClient!,
        );
      });
      test("version failed: rpc version to low", () {
        HttpOverrides.runZoned(
          () async {
            when(httpResponse!.transform(utf8.decoder)).thenAnswer((_) {
              return Stream.value(jsonEncode({
                TransmissionRpcResponseKey.result.keyName: "success",
                TransmissionRpcResponseKey.arguments.keyName: {
                  SessionGetArgument.rpcVersion.argName:
                      kMinimumSupportRpcVersion - 1,
                  SessionGetArgument.rpcVersionMinimum.argName: 1,
                },
              }));
            });

            final client = TransmissionRpcClient();
            await expectLater(client.init(),
                throwsA(const TypeMatcher<TransmissionVersionError>()));
            expect(client.isInited(), false);
            expect(client.serverRpcVersion, isNull);
          },
          createHttpClient: (_) => httpClient!,
        );
      });
      test("version failed: negative version", () {
        HttpOverrides.runZoned(
          () async {
            when(httpResponse!.transform(utf8.decoder)).thenAnswer((_) {
              return Stream.value(jsonEncode({
                TransmissionRpcResponseKey.result.keyName: "success",
                TransmissionRpcResponseKey.arguments.keyName: {
                  SessionGetArgument.rpcVersion.argName:
                      kMinimumSupportRpcVersion + 1,
                  SessionGetArgument.rpcVersionMinimum.argName: -1,
                },
              }));
            });

            final client = TransmissionRpcClient();
            await expectLater(client.init(),
                throwsA(const TypeMatcher<TransmissionVersionError>()));
            expect(client.isInited(), false);
            expect(client.serverRpcVersion, isNull);
          },
          createHttpClient: (_) => httpClient!,
        );
      });
      test("response failed", () {
        HttpOverrides.runZoned(
          () async {
            for (var testcase in [
              {
                TransmissionRpcResponseKey.result.keyName: "some reason",
                TransmissionRpcResponseKey.arguments.keyName: {
                  SessionGetArgument.rpcVersion.argName: 100,
                  SessionGetArgument.rpcVersionMinimum.argName: 1,
                }
              },
              {
                TransmissionRpcResponseKey.result.keyName: "success",
                TransmissionRpcResponseKey.arguments.keyName: {}
              },
              {
                TransmissionRpcResponseKey.result.keyName: "success",
                TransmissionRpcResponseKey.arguments.keyName: {
                  SessionGetArgument.rpcVersionMinimum.argName: 1,
                }
              },
              {
                TransmissionRpcResponseKey.result.keyName: "success",
                TransmissionRpcResponseKey.arguments.keyName: {
                  SessionGetArgument.rpcVersion.argName: 100,
                }
              }
            ]) {
              when(httpResponse!.transform(utf8.decoder)).thenAnswer((_) {
                return Stream.value(jsonEncode(testcase));
              });

              final client = TransmissionRpcClient();
              await expectLater(client.init(),
                  throwsA(predicate((e) => e is TransmissionError)),
                  reason: "failed, case: $testcase");
              expect(client.isInited(), false,
                  reason: "failed, case: $testcase");
              expect(client.serverRpcVersion, isNull,
                  reason: "failed, case: $testcase");
            }
          },
          createHttpClient: (_) => httpClient!,
        );
      });
    });

void main() {
  testTransmissionRpcClient();
  testTransmissionRpcClientInit();
}
