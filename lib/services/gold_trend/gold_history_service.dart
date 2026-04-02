import '../../data/gold_snapshot.dart';

class GoldHistoryService {
  List<GoldSnapshot> mergeSnapshots({
    required List<GoldSnapshot> existingSnapshots,
    required List<GoldSnapshot> incomingSnapshots,
  }) {
    final result = [...existingSnapshots];

    for (final incoming in incomingSnapshots) {
      final snapshotsForCharacter = result
          .where((snapshot) => snapshot.characterKey == incoming.characterKey)
          .toList();

      if (snapshotsForCharacter.isEmpty) {
        result.add(incoming);
        continue;
      }

      snapshotsForCharacter.sort(
        (a, b) => a.lastLogoutTimestamp.compareTo(b.lastLogoutTimestamp),
      );

      final latest = snapshotsForCharacter.last;

      final isNewerTimestamp =
          incoming.lastLogoutTimestamp > latest.lastLogoutTimestamp;
      final hasGoldChanged = incoming.goldCopper != latest.goldCopper;

      if (isNewerTimestamp && hasGoldChanged) {
        result.add(incoming);
      }
    }

    result.sort(
      (a, b) => a.lastLogoutTimestamp.compareTo(b.lastLogoutTimestamp),
    );

    return result;
  }
}
