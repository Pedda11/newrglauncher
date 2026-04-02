import 'dart:convert';
import 'dart:io';

import '../data/gold_snapshot.dart';
import '../widgets/paths.dart';

class GoldHistoryRepository {
  GoldHistoryRepository();

  File get _file => File(Paths.goldHistoryFile());

  Future<List<GoldSnapshot>> readSnapshots() async {
    if (!await _file.exists()) {
      return [];
    }

    final content = await _file.readAsString();

    if (content.trim().isEmpty) {
      return [];
    }

    final decoded = json.decode(content) as List<dynamic>;

    return decoded
        .map((e) => GoldSnapshot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeSnapshots(List<GoldSnapshot> snapshots) async {
    await Paths.ensureDataDirExists();
    final encoded = json.encode(
      snapshots.map((e) => e.toJson()).toList(),
    );

    await _file.writeAsString(encoded, flush: true);
  }
}
