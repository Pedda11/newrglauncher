import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/data/altoholic.dart';
import 'package:twodotnulllauncher/repository/gold_history_repository.dart';
import 'package:twodotnulllauncher/services/gold_trend/gold_aggregation_service.dart';
import 'package:twodotnulllauncher/services/gold_trend/gold_history_service.dart';
import 'package:twodotnulllauncher/utils/gold_snapshot_builder.dart';

void main() {
  test('current total gold changes only when history changes', () async {
    final testFilePath = 'test/tmp/gold_aggregation_test.json';
    final testFile = File(testFilePath);
    final testDir = Directory('test/tmp');

    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    if (await testFile.exists()) {
      await testFile.delete();
    }

    final repo = GoldHistoryRepository(customPath: testFilePath);
    final historyService = GoldHistoryService();
    final aggregationService = GoldAggregationService();

    /// STEP 1: initial import
    final initialContent =
        await File('test/fixtures/characters/initial.lua').readAsString();

    final initialChars = Altoholic.getCharData(initialContent, initialContent);

    final initialSnapshots = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: initialChars,
    );

    final merged1 = historyService.mergeSnapshots(
      existingSnapshots: [],
      incomingSnapshots: initialSnapshots,
    );

    await repo.writeSnapshots(merged1);

    final stored1 = await repo.readSnapshots();
    final total1 = aggregationService.calculateCurrentTotalGoldCopper(stored1);

    expect(total1, greaterThan(0));

    /// STEP 2: same import again -> total must stay the same
    final sameSnapshots = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: initialChars,
    );

    final merged2 = historyService.mergeSnapshots(
      existingSnapshots: stored1,
      incomingSnapshots: sameSnapshots,
    );

    await repo.writeSnapshots(merged2);

    final stored2 = await repo.readSnapshots();
    final total2 = aggregationService.calculateCurrentTotalGoldCopper(stored2);

    expect(total2, total1);

    /// STEP 3: changed import -> total should change
    final changedContent =
        await File('test/fixtures/characters/after_transfer.lua')
            .readAsString();

    final changedChars = Altoholic.getCharData(changedContent, changedContent);

    final changedSnapshots = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: 'TEST',
      characters: changedChars,
    );

    final merged3 = historyService.mergeSnapshots(
      existingSnapshots: stored2,
      incomingSnapshots: changedSnapshots,
    );

    await repo.writeSnapshots(merged3);

    final stored3 = await repo.readSnapshots();
    final total3 = aggregationService.calculateCurrentTotalGoldCopper(stored3);

    expect(total3, isNot(total2));
  });
}
