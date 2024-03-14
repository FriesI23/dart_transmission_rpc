// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

class TorrentId {
  final String? hasString;
  final int? id;

  const TorrentId({this.hasString, this.id})
      : assert(!(hasString == null && id == null));

  dynamic toRpcJson() => hasString ?? id!;
}

class TorrentIds {
  final List<TorrentId> ids;

  const TorrentIds(this.ids);

  factory TorrentIds.recently() => RecentlyActiveTorrentIds();

  bool get isEmpty => ids.isEmpty;

  bool get isNotEmpty => !isEmpty;

  dynamic toRpcJson() => ids.map((e) => e.toRpcJson());
}

class RecentlyActiveTorrentIds implements TorrentIds {
  @override
  List<TorrentId> get ids => [];

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  String toRpcJson() => "recently-active";
}
