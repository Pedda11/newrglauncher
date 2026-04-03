import 'dart:io';
import '../data/account.dart';
import '../data/account_refresh_result.dart';
import '../data/altoholic.dart';
import '../repository/gold_history_repository.dart';
import '../repository/main_repository.dart';
import '../repository/settings_repository.dart';
import '../utils/gold_snapshot_builder.dart';
import '../widgets/log.dart';
import 'gold_trend/gold_aggregation_service.dart';
import 'gold_trend/gold_history_service.dart';

class AccountDataRefreshService {
  final MainRepository mainRepository;
  final SettingsRepository settingsRepository;

  AccountDataRefreshService({
    required this.mainRepository,
    required this.settingsRepository,
  });

  Future<AccountRefreshResult> refreshAccount(Account acc) async {
    await Log.i('Refreshing account data for account: ${acc.accId}');

    final charsPath =
        '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\Rising-Gods';

    final dir = Directory(charsPath);
    final entities = await dir.list().toList();

    await Log.i(
      'Found ${entities.length} character directories for account: ${acc.accId}',
    );

    final charsPathAltoholic =
        '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\DataStore_Characters.lua';

    final savedInstancesPathAltoholic =
        '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\Altoholic.lua';

    await Log.i(
      'Reading Altoholic files for account: ${acc.accId}',
    );

    final altoChars = File(charsPathAltoholic);
    final charData = await altoChars.readAsString();

    final altoInstances = File(savedInstancesPathAltoholic);
    final charInstances = await altoInstances.readAsString();

    final characters = Altoholic.getCharData(charData, charInstances);

    final accountInList = mainRepository.accountList.firstWhere(
      (element) => element.accountName == acc.accountName,
    );

    accountInList.accChars = characters;

    final goldSnapshots = GoldSnapshotBuilder.buildGoldSnapshots(
      accountName: acc.accountName.toUpperCase(),
      characters: characters,
    );

    if (acc.includeInGoldTrend) {
      final goldHistoryRepository = GoldHistoryRepository();
      final goldHistoryService = GoldHistoryService();

      final existingSnapshots = await goldHistoryRepository.readSnapshots();

      final mergedSnapshots = goldHistoryService.mergeSnapshots(
        existingSnapshots: existingSnapshots,
        incomingSnapshots: goldSnapshots,
      );

      await goldHistoryRepository.writeSnapshots(mergedSnapshots);

      await Log.i(
        'Gold history updated for account: ${acc.accId}, '
        'existing: ${existingSnapshots.length}, '
        'incoming: ${goldSnapshots.length}, '
        'merged: ${mergedSnapshots.length}',
      );
    }

    final goldHistoryRepository = GoldHistoryRepository();
    final goldAggregationService = GoldAggregationService();

    final snapshots = await goldHistoryRepository.readSnapshots();

    final totalCopper =
        goldAggregationService.calculateCurrentTotalGoldCopper(snapshots);

    final goldTimeline =
        goldAggregationService.buildTotalGoldTimeline(snapshots);

    final dailyGoldTimeline =
        goldAggregationService.compressTimelineToDailyLastValue(goldTimeline);

    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 30));

    final filteredTimeline = dailyGoldTimeline.where((e) {
      final date =
          DateTime.fromMillisecondsSinceEpoch(e.lastLogoutTimestamp * 1000);
      return date.isAfter(cutoff);
    }).toList();

    final chartPoints =
        goldAggregationService.buildChartPoints(filteredTimeline);

    final forecastPoints =
        goldAggregationService.buildForecastPoints(chartPoints);

    await Log.i('Current total gold copper: $totalCopper');
    await Log.i(
      'Current total gold formatted: ${Altoholic.formatCoins(totalCopper)}',
    );
    await Log.i(
      'Built ${goldSnapshots.length} gold snapshots for accountId: ${acc.accId}',
    );
    await Log.i(
      'Finished refreshing account: ${acc.accId}, total characters loaded: ${characters.length}',
    );

    return AccountRefreshResult(
      characters: characters,
      totalGoldCopper: totalCopper,
      chartPoints: chartPoints,
      forecastPoints: forecastPoints,
    );
  }
}
