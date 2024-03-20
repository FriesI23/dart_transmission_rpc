<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# Dart Transmission RPC

![Package][pubdev-package]
![Likes][pubdev-likes]
![Popularity][pubdev-popularity]
![Points][pubdev-points]

`dart_transmission_rpc` is a Transmission RPC client implemented in Dart,
supporting `rpc-version>=14`. for more information,
see [Transmission/rpc-spec.md][rpc-spec.md].

## Features

Following interfaces have been implemented:

- [x] torrent
  - [x] torrent-start
  - [x] torrent-start-now
  - [x] torrent-stop
  - [x] torrent-verify
  - [x] torrent-reannounce
  - [x] torrent-set
  - [x] torrent-get
  - [x] torrent-add
  - [x] torrent-remove
  - [x] torrent-set-location
  - [x] torrent-rename-path
- [x] session
  - [x] session-get
  - [x] session-set
  - [x] session-stats
  - [x] blocklist-update
  - [x] port-test
  - [x] session-close
  - [x] queue-move-top
  - [x] queue-move-up
  - [x] queue-move-down
  - [x] queue-move-bottom
  - [x] free-space
  - [x] group-set
  - [x] group-get

## Getting started

### Add dependency with `dart pub add` command

```shell
dart pub add dart_transmission_rpc
```

### **Or** Add below line to `pubspec.yaml`

```yaml
dependencies:
  ...
  dart_transmission_rpc: any  # or special version

```

Then run `dart pub get`, or `flutter pub get` for flutter project.

## Usage

```dart
final client = TransmissionRpcClient(
  username: "admin", password: "123456");
await client.init();

// get session info
final sessionInfo = await client.sessionGet(null);

// get torrent info
final torrentInfo = await client.torrentGet([
  TorrentGetArgument.name,
  TorrentGetArgument.id,
  TorrentGetArgument.hashString,
  TorrentGetArgument.addedDate,
  TorrentGetArgument.pieces,
]);

// add torrent
await client.torrentAdd(
  TorrentAddRequestArgs(
    fileInfo: TorrentAddFileInfo.byMetainfo(
        io.File("demo/demo_test.torrent").readAsBytesSync()),
    downloadDir: "/downloads/complete",
    labels: ["test", "test1"],
  ),
);
// or
await client.torrentAdd(
  TorrentAddRequestArgs(
    fileInfo: TorrentAddFileInfo.byFilename(
        "magnet:?xt=urn:btih:cce82738e2f9217c5631549b0b8c1dfe12331503&dn=debian-12.5.0-i386-netinst.iso"),
    downloadDir: "/downloads",
    labels: ["test", "test1", "test2"],
  ),
  );
```

for more example see: [demo_test.dart](./demo/demo_test.dart)

## Donate

[!["Buy Me A Coffee"][buymeacoffee-badge]](https://www.buymeacoffee.com/d49cb87qgww)
[![Alipay][alipay-badge]][alipay-addr]
[![WechatPay][wechat-badge]][wechat-addr]

[![ETH][eth-badge]][eth-addr]
[![BTC][btc-badge]][btc-addr]

## License

```text
MIT License

Copyright (c) 2024 Fries_I23

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

[rpc-spec.md]: https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md#31-torrent-action-requests

[pubdev-package]: https://img.shields.io/pub/v/dart_transmission_rpc.svg
[pubdev-likes]: https://img.shields.io/pub/likes/dart_transmission_rpc?logo=dart
[pubdev-popularity]: https://img.shields.io/pub/popularity/dart_transmission_rpc?logo=dart
[pubdev-points]: https://img.shields.io/pub/points/dart_transmission_rpc?logo=dart

[buymeacoffee-badge]: https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black
[alipay-badge]: https://img.shields.io/badge/alipay-00A1E9?style=for-the-badge&logo=alipay&logoColor=white
[alipay-addr]: https://raw.githubusercontent.com/FriesI23/mhabit/main/docs/README/images/donate-alipay.jpg
[wechat-badge]: https://img.shields.io/badge/WeChat-07C160?style=for-the-badge&logo=wechat&logoColor=white
[wechat-addr]: https://raw.githubusercontent.com/FriesI23/mhabit/main/docs/README/images/donate-wechatpay.png
[eth-badge]: https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white
[eth-addr]: https://etherscan.io/address/0x35FC877Ef0234FbeABc51ad7fC64D9c1bE161f8F
[btc-badge]: https://img.shields.io/badge/Bitcoin-000000?style=for-the-badge&logo=bitcoin&logoColor=white
[btc-addr]: https://blockchair.com/bitcoin/address/bc1qz2vjews2fcscmvmcm5ctv47mj6236x9p26zk49
