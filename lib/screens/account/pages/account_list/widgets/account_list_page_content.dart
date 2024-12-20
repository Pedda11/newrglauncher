import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../repository/main_repository.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';
import '../../../cubit/character_cubit/character_data_cubit.dart';
import 'account_card.dart';
import 'account_data_card.dart';

class AccountListPageContent extends StatelessWidget {
  const AccountListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mainRepository = context.read<MainRepository>();
    final screenCubit = context.read<AccountScreenCubit>();
    final characterDataCubit = context.read<CharacterDataCubit>();
    final locales = Localize.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: BlocBuilder<AccountScreenCubit, AccountScreenState>(
            builder: (context, state) {
              return state.maybeWhen(
                initialized: (accList) => ListView.builder(
                  itemCount: accList.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            spacing: 20,
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            borderRadius: BorderRadius.circular(8),
                            flex: 1,
                            onPressed: (context) => {
                              screenCubit.deleteSingleAccount(
                                  mainRepository, accList[index]),
                            },
                          )
                        ],
                      ),
                      child: GestureDetector(
                        child: AccountCard(
                          acc: accList[index],
                        ),
                        onTap: () {
                          characterDataCubit.getAccountDetails(accList[index]);
                        },
                        onDoubleTap: () {
                          /*if (sCubit.wowGamePath != null) {
                            /// If there is a Wow game path selected
                            accCubit
                                .startProcessMonitoring(sCubit.wowGamePath!);

                            /// Start Wow game monitoring
                          }*/
                        },
                      ),
                    );
                  },
                ),
                noAccounts: () {
                  return const Center(
                    child: Text(
                      'No accounts saved yet!!!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  );
                },
                orElse: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: BlocBuilder<CharacterDataCubit, CharacterDataState>(
            builder: (context, state) {
              return state.maybeWhen(
                  initialized: (characterList) => Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: ListView.builder(
                          itemCount: characterList!.length,
                          itemBuilder: (context, index) {
                            return AccountDataCard(
                              character: characterList[index],
                            );
                          },
                        ),
                      ),
                  orElse: () => const Center(
                        child: Text(
                          'Keine Daten vorhanden!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ));
            },
          ),
        )
      ],
    );
  }
}
