// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import '../typedef.dart';

class TrackerListCodec with Codec<TrackerListIter, String> {
  const TrackerListCodec();

  @override
  Converter<TrackerListIter, String> get encoder => TrackerListEncoder();

  @override
  Converter<String, TrackerListIter> get decoder => TrackerListDecoder();
}

final class TrackerListEncoder with Converter<TrackerListIter, String> {
  @override
  String convert(TrackerListIter input) =>
      input.where((e) => e.isNotEmpty).map((x) => x.join("\n\n")).join("\n");
}

final class TrackerListDecoder with Converter<String, TrackerListIter> {
  @override
  TrackerListIter convert(String input) => input
      .split('\n')
      .where((e) => e.isNotEmpty)
      .map((tracker) => tracker.split('\n\n'));
}

const trackerListCodec = TrackerListCodec();
