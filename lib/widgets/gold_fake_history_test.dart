import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:twodotnulllauncher/data/gold_snapshot.dart';
import 'package:twodotnulllauncher/widgets/paths.dart';

Future<void> generateFakeGoldHistory() async {
  final random = Random(42);

  final List<GoldSnapshot> snapshots = [];

  final characters = [
    ('FIJETA', 'Peddalustig'),
    ('FIJETA', 'Peddatie'),
    ('FIJETA11', 'Agliasfak'),
  ];

  final now = DateTime.now();

  int totalGold = 1500000000; // ~150k Start

  for (int day = 30; day >= 0; day--) {
    final date = now.subtract(Duration(days: day));

    /// täglicher Fortschritt
    final dailyGain = 15000000; // +15k Gold pro Tag

    /// kleine Schwankung
    final fluctuation = random.nextInt(8000000) - 4000000;

    /// gelegentlicher Dip (z. B. Mount gekauft)
    final isDip = random.nextDouble() < 0.15;
    final dip = isDip ? -(20000000 + random.nextInt(20000000)) : 0;

    totalGold += dailyGain + fluctuation + dip;

    final perChar = totalGold ~/ characters.length;

    for (final (account, charName) in characters) {
      snapshots.add(
        GoldSnapshot(
          accountName: account,
          characterName: charName,
          realm: 'Rising-Gods',
          goldCopper: perChar + random.nextInt(3000000),
          lastLogoutTimestamp: date.millisecondsSinceEpoch ~/ 1000,
        ),
      );
    }
  }

  snapshots.sort(
    (a, b) => a.lastLogoutTimestamp.compareTo(b.lastLogoutTimestamp),
  );

  final file = File(Paths.goldHistoryFile());

  await file.create(recursive: true);

  await file.writeAsString(
    json.encode(snapshots.map((e) => e.toJson()).toList()),
    flush: true,
  );
}
