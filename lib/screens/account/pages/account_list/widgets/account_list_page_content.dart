import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../repository/error_repository.dart';
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
    final screenCubit = context.read<AccountScreenCubit>()..initialize();
    final characterDataCubit = context.read<CharacterDataCubit>();
    final locales = Localize.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    screenCubit.goToAccountAddPage();
                  },
                  child: Text(locales.accountListPageAddAccountBtn),
                ),
              ),
              Expanded(
                flex: 1,
                child: BlocConsumer<AccountScreenCubit, AccountScreenState>(
                  listener: (context, state) {
                    state.whenOrNull(
                      failed: (errorMsg) {
                        context.read<ErrorRepository>().sendErrorToServer(
                            errorMessage: errorMsg,
                            errorOnPosition:
                                'AccountListPageContent-AccountScreenCubit',
                            errorDateTime: DateTime.now().toString());
                        return showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(errorMsg),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(locales.ok),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      initialized: () => ListView.builder(
                        itemCount: mainRepository.accountList.length,
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
                                        mainRepository.accountList[index]),
                                  },
                                )
                              ],
                            ),
                            child: GestureDetector(
                              child: AccountCard(
                                acc: mainRepository.accountList[index],
                              ),
                              onTap: () {
                                characterDataCubit.getAccountDetails(
                                    mainRepository.accountList[index]);
                              },
                              onDoubleTap: () {
                                screenCubit.startGame(
                                    mainRepository.accountList[index]);
                              },
                            ),
                          );
                        },
                      ),
                      initial: () {
                        screenCubit.loadAccounts();
                        return const Center(
                          child: CircularProgressIndicator(),
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
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: BlocConsumer<CharacterDataCubit, CharacterDataState>(
            builder: (context, state) {
              return state.maybeWhen(
                  accountLoaded: (characterList) => Container(
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
            listener: (context, state) {
              state.whenOrNull(
                failed: (errorMsg) {
                  context.read<ErrorRepository>().sendErrorToServer(
                      errorMessage: errorMsg,
                      errorOnPosition:
                          'AccountListPageContent-CharacterDataCubit',
                      errorDateTime: DateTime.now().toString());
                  return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(errorMsg),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(locales.ok),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
