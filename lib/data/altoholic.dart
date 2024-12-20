
import '../utils/lua_to_json.dart';
import '../utils/utils.dart';
import 'character.dart';
import 'saved_instance.dart';

class Altoholic {
  static List<Character> getCharData(String charData, String charInstances) {
    List<Character> charList = [];

    charList = getGeneralData(charData);
    charList = getCharSavedInstances(charInstances, charList);

    return charList;
  }

  static String formatCoins(int copperCoins) {
    int gold = copperCoins ~/ 10000;
    int silver = (copperCoins % 10000) ~/ 100;
    int copper = copperCoins % 100;

    String result = '';
    if (gold > 0) {
      result += '$gold Gold';
      if (silver > 0 || copper > 0) {
        result += ', ';
      }
    }
    if (silver > 0) {
      result += '$silver Silber';
      if (copper > 0) {
        result += ', ';
      }
    }
    if (copper > 0 || (gold == 0 && silver == 0 && copper == 0)) {
      result += '$copper Kupfer';
    }

    return result;
  }

  static List<Character> getGeneralData(String content) {
    List<Character> list = [];

    Map<String, dynamic> data = LuaToJson.parseLua(content);

    if (data.containsKey('global') &&
        data['global'].containsKey('Characters')) {
      Map<String, dynamic> charactersMap = data['global']['Characters'];

      for (var m in charactersMap.entries) {
        var splitKey = m.key.split('.');
        String name = splitKey[splitKey.length - 1];
        Map<String, dynamic> val = m.value;

        String faction = '';
        String guildName = '';
        String guildRank = '';
        String money = '';
        String charClass = '';
        String zone = '';
        String subZone = '';
        String lastLogout = '';

        for (var n in val.entries) {
          if (n.key == 'faction') {
            faction = n.value ?? '';
          } else if (n.key == 'guildName') {
            guildName = n.value ?? '';
          } else if (n.key == 'guildRankName') {
            guildRank = n.value ?? '';
          } else if (n.key == 'money') {
            money = formatCoins(n.value);
          } else if (n.key == 'class') {
            charClass = n.value ?? '';
          } else if (n.key == 'zone') {
            zone = n.value ?? '';
          } else if (n.key == 'subZone') {
            subZone = n.value ?? '';
          } else if (n.key == 'lastLogoutTimestamp') {
            lastLogout = Utils.timeSpanToDateTime(n.value);
          }
        }

        list.add(
          Character(
              name: name,
              faction: faction,
              guildName: guildName,
              guildRank: guildRank,
              charClass: charClass,
              zone: zone,
              subZone: subZone,
              money: money,
              lastLogout: lastLogout,
              savedInstances: []),
        );
      }
    }
    return list;
  }

  static List<Character> getCharSavedInstances(
      String charInstances, List<Character> charList) {
    Map<String, dynamic> data = LuaToJson.parseLua(charInstances);

    if (data.containsKey('global') &&
        data['global'].containsKey('Characters')) {
      Map<String, dynamic> charactersMap = data['global']['Characters'];

      for (Character c in charList) {
        for (var m in charactersMap.entries) {
          var splitKey = m.key.split('.');
          String name = splitKey[splitKey.length - 1];
          Map<String, dynamic> val = m.value;

          if (val.entries.length > 1) {
            String title = '';
            int id = 0;
            String resetDate = '';

            for (var n in val.entries) {
              if (n.key == 'SavedInstance') {
                Map<String, dynamic> val2 = n.value;
                if (c.name == name) {
                  for (var o in val2.entries) {
                    var splitedKey = o.key.split('|');
                    title = splitedKey[0];
                    id = int.parse(splitedKey[1]);

                    var splitedValue = o.value.split('|');
                    resetDate = Utils.timeSpanToDateTime(
                        int.parse(splitedValue[0]) +
                            int.parse(splitedValue[1]));
                    SavedInstance savedInstance = SavedInstance(
                        title: title, id: id, resetDay: resetDate);
                    c.savedInstances.add(savedInstance);
                  }
                }
              }
            }
          }
        }
      }
    }
    return charList;
  }
}
