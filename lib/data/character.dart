import 'saved_instance.dart';

class Character {
  String name;
  String faction;
  String guildName;
  String guildRank;
  String money;
  String charClass;
  String zone;
  String subZone;
  String lastLogout;
  List<SavedInstance> savedInstances = [];

  Character({
    required this.name,
    required this.faction,
    required this.guildName,
    required this.charClass,
    required this.guildRank,
    required this.money,
    required this.subZone,
    required this.zone,
    required this.lastLogout,
    required this.savedInstances,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json["name"],
        faction: json["faction"],
        guildName: json["guildName"],
        charClass: json["charClass"],
        guildRank: json["guildRank"],
        money: json["money"],
        subZone: json["subZone"],
        zone: json["zone"],
        lastLogout: json["lastLogout"],
        savedInstances: List<SavedInstance>.from(
            json["savedInstances"].map((x) => SavedInstance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "faction": faction,
        "guildName": guildName,
        "charClass": charClass,
        "guildRank": guildRank,
        "money": money,
        "subZone": subZone,
        "zone": zone,
        "lastLogout": lastLogout,
        "savedInstances":
            List<dynamic>.from(savedInstances.map((x) => x.toJson())),
      };
}
