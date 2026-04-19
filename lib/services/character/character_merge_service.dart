import '../../data/character.dart';

class CharacterMergeService {
  static List<Character> mergeWithLocalMeta({
    required List<Character> incomingCharacters,
    required List<Character>? existingCharacters,
  }) {
    /// No old data available, so initialize a stable default order.
    if (existingCharacters == null || existingCharacters.isEmpty) {
      for (int i = 0; i < incomingCharacters.length; i++) {
        incomingCharacters[i].sortIndex = i;
      }
      return incomingCharacters;
    }

    /// Build lookup by character name.
    final existingByName = <String, Character>{
      for (final c in existingCharacters) c.name: c,
    };

    final merged = incomingCharacters.map((incoming) {
      final existing = existingByName[incoming.name];

      if (existing != null) {
        incoming.sortIndex = existing.sortIndex;
        incoming.isShown = existing.isShown;
      }

      return incoming;
    }).toList();

    /// Assign sortIndex to new characters that did not exist before.
    final usedIndexes =
        merged.where((c) => c.sortIndex >= 0).map((c) => c.sortIndex).toSet();

    var nextFreeIndex = 0;
    for (final character in merged) {
      final hadExistingEntry = existingByName.containsKey(character.name);
      if (hadExistingEntry) {
        continue;
      }

      while (usedIndexes.contains(nextFreeIndex)) {
        nextFreeIndex++;
      }

      character.sortIndex = nextFreeIndex;
      usedIndexes.add(nextFreeIndex);
    }

    merged.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    return merged;
  }
}
