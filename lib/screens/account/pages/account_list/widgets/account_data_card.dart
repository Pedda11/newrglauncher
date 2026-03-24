import 'package:flutter/material.dart';

import '../../../../../data/character.dart';
import '../../../../../localization/generated/l10n.dart';

class AccountDataCard extends StatelessWidget {
  final Character character;

  const AccountDataCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
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
                Text(
                  locales.accountDataCardNameLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  character.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      locales.accountDataCardGuildLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.guildName == ''
                        ? locales.accountDataCardNoGuild
                        : character.guildName),
                    Text(character.guildRank == ''
                        ? locales.accountDataCardGuild
                        : '/${character.guildRank}'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      locales.accountDataCardFactionLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    Text(
                      locales.accountDataCardZoneLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.zone),
                    Text('/${character.subZone}'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      locales.accountDataCardClassLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    Text(
                      locales.accountDataCardGoldLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(character.money),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      locales.accountDataCardLastLogoutLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          Text(
                            locales.accountDataCardInstancesTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(),
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
                                              locales.accountDataCardNullValue),
                                          Text(character
                                              .savedInstances[index].resetDay!)
                                        ],
                                      ),
                                      const Divider(),
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
