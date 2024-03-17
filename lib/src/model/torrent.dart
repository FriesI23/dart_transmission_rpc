// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

class TorrentId {
  final String? hashStr;
  final int? id;

  const TorrentId({this.hashStr, this.id})
      : assert(!(hashStr == null && id == null));

  dynamic toRpcJson() => hashStr ?? id!;

  @override
  String toString() => "TorrentId {id: $id, hash: $hashStr}";
}

class TorrentIds<T extends TorrentId> with Iterable<T> {
  final List<T> ids;

  const TorrentIds(this.ids);

  const TorrentIds.empty() : ids = const [];

  factory TorrentIds.recently() => RecentlyActiveTorrentIds();

  factory TorrentIds.torrentSetForAll() => const TorrentIds.empty();

  dynamic toRpcJson() => ids.map((e) => e.toRpcJson()).toList();

  @override
  Iterator<T> get iterator => ids.iterator;
}

class RecentlyActiveTorrentIds<T extends TorrentId>
    with Iterable<T>
    implements TorrentIds<T> {
  @override
  List<T> get ids => const [];

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  String toRpcJson() => "recently-active";

  @override
  Iterator<T> get iterator => ids.iterator;
}

class FileIndices with Iterable<int> {
  final List<int> indices;

  const FileIndices(this.indices);

  const FileIndices.empty() : indices = const [];

  factory FileIndices.torrentSetForAll() => const FileIndices.empty();

  dynamic toRpcJson() => indices;

  @override
  Iterator<int> get iterator => indices.iterator;
}
