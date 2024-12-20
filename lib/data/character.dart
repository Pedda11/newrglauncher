
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
}
