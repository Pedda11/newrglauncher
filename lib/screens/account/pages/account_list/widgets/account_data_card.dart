
import 'package:flutter/material.dart';

import '../../../../../data/character.dart';

class AccountDataCard extends StatelessWidget {
  final Character character;
  const AccountDataCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  character.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Divider(

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Gilde: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.guildName == ''
                        ? 'Keine '
                        : character.guildName),
                    Text(character.guildRank == ''
                        ? 'Gilde'
                        : '/${character.guildRank}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Fraktion: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.faction),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Zone: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.zone),
                    Text('/${character.subZone}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Klasse: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.charClass),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Gold: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.money),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Zuletzt Online: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.lastLogout),
                  ],
                ),
              ],
            ),
            character.savedInstances.isNotEmpty
                ? Container(
                    color: const Color(0xFF8F8F8F),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "ID's",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: character.savedInstances.length,
                              itemBuilder: (context, index) {
                                if (character.savedInstances.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(character
                                              .savedInstances[index].id
                                              .toString()),
                                          Text(character.savedInstances[index]
                                                  .title ??
                                              'NULL'),
                                          Text(character
                                              .savedInstances[index].resetDay!)
                                        ],
                                      ),
                                      const Divider(
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
