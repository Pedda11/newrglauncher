class GoldSnapshot {
  final String accountName;
  final String characterName;
  final String realm;
  final int goldCopper;
  final int lastLogoutTimestamp;

  GoldSnapshot({
    required this.accountName,
    required this.characterName,
    required this.realm,
    required this.goldCopper,
    required this.lastLogoutTimestamp,
  });

  factory GoldSnapshot.fromJson(Map<String, dynamic> json) {
    return GoldSnapshot(
      accountName: json['accountName'],
      characterName: json['characterName'],
      realm: json['realm'],
      goldCopper: json['goldCopper'],
      lastLogoutTimestamp: json['lastLogoutTimestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'characterName': characterName,
        'realm': realm,
        'goldCopper': goldCopper,
        'lastLogoutTimestamp': lastLogoutTimestamp,
      };

  String get characterKey => '$accountName|$realm|$characterName';
}
