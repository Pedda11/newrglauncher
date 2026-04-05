import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../repository/error_repository.dart';
import '../../../../../repository/main_repository.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';
import '../../../cubit/character_cubit/character_data_cubit.dart';
import '../cubit/acc_list_page_cubit.dart';
import 'account_card.dart';
import 'account_data_card.dart';

class AccountListPageContent extends StatelessWidget {
  const AccountListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<AccountScreenCubit>()..initialize();
    final pageCubit = context.read<AccListPageCubit>();
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
                      initialized: () {
                        pageCubit.loadAccounts();
                      },
                      failed: (errorMsg) {
                        return showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(locales.error),
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
                      initialized: () {
                        return BlocBuilder<AccListPageCubit, AccListPageState>(
                            builder: (context, state) => state.maybeWhen(
                                  orElse: () {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  reordered: (accounts) {
                                    return ReorderableListView.builder(
                                        buildDefaultDragHandles: false,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            key: ValueKey(
                                                accounts[index].uniqueId),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Slidable(
                                              endActionPane: ActionPane(
                                                motion: const StretchMotion(),
                                                extentRatio: 0.25,
                                                children: [
                                                  SlidableAction(
                                                    foregroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    onPressed: (context) => {
                                                      screenCubit
                                                          .deleteSingleAccount(
                                                              accounts[index]),
                                                    },
                                                  ),
                                                  SlidableAction(
                                                    foregroundColor:
                                                        Colors.green,
                                                    icon: Icons.edit,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    onPressed: (context) => {
                                                      screenCubit.editAccount(
                                                          accounts[index]),
                                                    },
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  ReorderableDragStartListener(
                                                    index: index,
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: Icon(
                                                          Icons.drag_handle),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: AccountCard(
                                                        acc: accounts[index]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: accounts.length,
                                        onReorder: (oldIndex, newIndex) {
                                          pageCubit.reorderAccounts(
                                              oldIndex, newIndex);
                                        });
                                  },
                                ));
                      },
                      initial: () {
                        screenCubit.loadAccounts();
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      goToAddAccountPage: () {
                        return Center(
                          child: Text(locales.accountListPageNoAccountsLabel),
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
                  return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(locales.error),
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
