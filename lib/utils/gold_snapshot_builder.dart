import '../data/character.dart';
import '../data/gold_snapshot.dart';

class GoldSnapshotBuilder {
  static List<GoldSnapshot> buildGoldSnapshots({
    required String accountName,
    required List<Character> characters,
  }) {
    final snapshots = <GoldSnapshot>[];

    for (final c in characters) {
      // Skip invalid data
      if (c.moneyCopper <= 0 && c.lastLogoutTimestamp == 0) {
        continue;
      }

      snapshots.add(
        GoldSnapshot(
          accountName: accountName,
          characterName: c.name,
          realm: 'Rising-Gods',
          goldCopper: c.moneyCopper,
          lastLogoutTimestamp: c.lastLogoutTimestamp,
        ),
      );
    }

    return snapshots;
  }
}
