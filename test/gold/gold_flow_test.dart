import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/data/altoholic.dart';
import 'package:twodotnulllauncher/repository/gold_history_repository.dart';
import 'package:twodotnulllauncher/services/gold_trend/gold_history_service.dart';
import 'package:twodotnulllauncher/utils/gold_snapshot_builder.dart';

void main() {
  test('gold history grows only on real changes', () async {
    final testFilePath = 'test/tmp/gold_history_test.json';

    final testFile = File(testFilePath);

    // clean previous test run
    if (await testFile.exists()) {
      await testFile.delete();
    }

    final testDir = Directory('test/tmp');

    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    if (await testFile.exists()) {
      await testFile.delete();
    }

    final repo = GoldHistoryRepository(customPath: testFilePath);
    final service = GoldHistoryService();

    /// --- STEP 1: initial load ---
    final initialContent =
        await File('test/fixtures/characters/initial.lua').readAsString();

    final chars1 = Altoholic.getCharData(initialContent, initialContent);

    final snapshots1 = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: chars1,
    );

    final merged1 = service.mergeSnapshots(
      existingSnapshots: [],
      incomingSnapshots: snapshots1,
    );

    await repo.writeSnapshots(merged1);

    final stored1 = await repo.readSnapshots();

    expect(stored1.length, snapshots1.length);

    /// --- STEP 2: same data again ---
    final snapshots2 = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: chars1,
    );

    final merged2 = service.mergeSnapshots(
      existingSnapshots: stored1,
      incomingSnapshots: snapshots2,
    );

    await repo.writeSnapshots(merged2);

    final stored2 = await repo.readSnapshots();

    expect(stored2.length, stored1.length);

    /// --- STEP 3: after transfer ---
    final changedContent =
        await File('test/fixtures/characters/after_transfer.lua')
            .readAsString();

    final chars2 = Altoholic.getCharData(changedContent, changedContent);

    final snapshots3 = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: chars2,
    );

    final merged3 = service.mergeSnapshots(
      existingSnapshots: stored2,
      incomingSnapshots: snapshots3,
    );

    await repo.writeSnapshots(merged3);

    final stored3 = await repo.readSnapshots();

    expect(stored3.length > stored2.length, true);
  });
}
