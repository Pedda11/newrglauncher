import 'saved_instance.dart';

class Character {
  String name;
  String faction;
  String guildName;
  String guildRank;
  String money;
  int moneyCopper;
  String charClass;
  String zone;
  String subZone;
  String lastLogout;
  int lastLogoutTimestamp;
  List<SavedInstance> savedInstances = [];

  Character({
    required this.name,
    required this.faction,
    required this.guildName,
    required this.charClass,
    required this.guildRank,
    required this.money,
    required this.moneyCopper,
    required this.subZone,
    required this.zone,
    required this.lastLogout,
    required this.lastLogoutTimestamp,
    required this.savedInstances,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json["name"],
        faction: json["faction"],
        guildName: json["guildName"],
        charClass: json["charClass"],
        guildRank: json["guildRank"],
        money: json["money"],
        moneyCopper: json["moneyCopper"] ?? 0,
        subZone: json["subZone"],
        zone: json["zone"],
        lastLogout: json["lastLogout"],
        lastLogoutTimestamp: json["lastLogoutTimestamp"] ?? 0,
        savedInstances: List<SavedInstance>.from(
          json["savedInstances"].map((x) => SavedInstance.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "faction": faction,
        "guildName": guildName,
        "charClass": charClass,
        "guildRank": guildRank,
        "money": money,
        "moneyCopper": moneyCopper,
        "subZone": subZone,
        "zone": zone,
        "lastLogout": lastLogout,
        "lastLogoutTimestamp": lastLogoutTimestamp,
        "savedInstances":
            List<dynamic>.from(savedInstances.map((x) => x.toJson())),
      };
}
