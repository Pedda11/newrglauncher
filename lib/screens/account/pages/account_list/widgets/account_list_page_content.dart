import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../repository/error_repository.dart';
import '../../../../../repository/main_repository.dart';
import '../../../../../theme/helpers/theme_context_extensions.dart';
import '../../../../../widgets/launcher_button.dart';
import '../../../../../widgets/launcher_panel.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';
import '../../../cubit/character_cubit/character_data_cubit.dart';
import '../cubit/acc_list_page_cubit.dart';
import 'account_card.dart';
import 'account_data_card.dart';

class AccountListPageContent extends StatelessWidget {
  const AccountListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<AccountScreenCubit>();
    final pageCubit = context.read<AccListPageCubit>();
    final characterDataCubit = context.read<CharacterDataCubit>();
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final text = context.launcherText;
    final radius = context.launcherRadius;
    return Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LauncherPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LauncherButton(
                        label: locales.accountListPageAddAccountBtn,
                        onPressed: () {
                          screenCubit.goToAccountAddPage();
                        },
                      ),
                    ),
                    SizedBox(height: spacing.lg),
                    Expanded(
                      child:
                          BlocConsumer<AccountScreenCubit, AccountScreenState>(
                        listener: (context, state) {
                          state.whenOrNull(
                            initialized: () {
                              pageCubit.loadAccounts();
                            },
                            failed: (errorMsg) async {
                              final result = await showDialog(
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
                              screenCubit.initialize();
                            },
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            initialized: () {
                              return BlocBuilder<AccListPageCubit,
                                      AccListPageState>(
                                  builder: (context, state) => state.maybeWhen(
                                        orElse: () {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        reordered: (accounts) {
                                          return ReorderableListView.builder(
                                              buildDefaultDragHandles: false,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  key: ValueKey(
                                                      accounts[index].uniqueId),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: spacing.sm),
                                                  child: Slidable(
                                                    endActionPane: ActionPane(
                                                      motion:
                                                          const StretchMotion(),
                                                      extentRatio: 0.35,
                                                      children: [
                                                        SlidableAction(
                                                          backgroundColor:
                                                              colors.errorText
                                                                  .withValues(
                                                                      alpha:
                                                                          0.15),
                                                          foregroundColor:
                                                              colors.errorText,
                                                          icon: Icons
                                                              .delete_rounded,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(radius
                                                                      .small),
                                                          onPressed: (_) {
                                                            screenCubit
                                                                .deleteSingleAccount(
                                                                    accounts[
                                                                        index]);
                                                          },
                                                        ),
                                                        SlidableAction(
                                                          backgroundColor:
                                                              colors.accent
                                                                  .withValues(
                                                                      alpha:
                                                                          0.15),
                                                          foregroundColor:
                                                              colors.accent,
                                                          icon: Icons
                                                              .edit_rounded,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(radius
                                                                      .small),
                                                          onPressed: (_) {
                                                            screenCubit
                                                                .editAccount(
                                                                    accounts[
                                                                        index]);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        ReorderableDragStartListener(
                                                          index: index,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        spacing
                                                                            .sm),
                                                            child: Container(
                                                              width: 28,
                                                              height: 28,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            radius.small),
                                                                color: colors
                                                                    .inputBackground
                                                                    .withValues(
                                                                        alpha:
                                                                            0.85),
                                                                border:
                                                                    Border.all(
                                                                  color: colors
                                                                      .accent
                                                                      .withValues(
                                                                          alpha:
                                                                              0.18),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .drag_indicator_rounded,
                                                                size: 18,
                                                                color: colors
                                                                    .mutedText,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: BlocBuilder<
                                                              CharacterDataCubit,
                                                              CharacterDataState>(
                                                            builder: (context,
                                                                characterState) {
                                                              String?
                                                                  selectedAccountId =
                                                                  characterState
                                                                      .maybeWhen(
                                                                accountLoaded: (account,
                                                                        characterList) =>
                                                                    account
                                                                        .uniqueId,
                                                                orElse: () =>
                                                                    null,
                                                              );

                                                              final isSelected =
                                                                  selectedAccountId ==
                                                                      accounts[
                                                                              index]
                                                                          .uniqueId;

                                                              return AccountCard(
                                                                acc: accounts[
                                                                    index],
                                                                isSelected:
                                                                    isSelected,
                                                                onTap: () => characterDataCubit
                                                                    .getAccountDetails(
                                                                        accounts[
                                                                            index]),
                                                                onDoubleTap: () =>
                                                                    screenCubit.startGame(
                                                                        accounts[
                                                                            index]),
                                                              );
                                                            },
                                                          ),
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
                                child: Text(
                                    locales.accountListPageNoAccountsLabel),
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
            ),
            Container(
              width: 1,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    colors.panelBorder.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: LauncherPanel(
                  child: BlocConsumer<CharacterDataCubit, CharacterDataState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                          accountLoaded: (account, characterList) => Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(radius.panel),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colors.panelBackground
                                          .withValues(alpha: 0.72),
                                      colors.panelBackground
                                          .withValues(alpha: 0.60),
                                    ],
                                  ),
                                ),
                                child: ReorderableListView.builder(
                                  buildDefaultDragHandles: false,
                                  itemCount: characterList.length,
                                  onReorder: (oldIndex, newIndex) {
                                    characterDataCubit.reorderCharacters(
                                      account,
                                      oldIndex,
                                      newIndex,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final character = characterList[index];

                                    return Padding(
                                      key: ValueKey(character.name),
                                      padding: EdgeInsets.symmetric(
                                          vertical: spacing.sm),
                                      child: Row(
                                        children: [
                                          ReorderableDragStartListener(
                                            index: index,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: spacing.sm),
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radius.small),
                                                  color: colors.inputBackground
                                                      .withValues(alpha: 0.85),
                                                  border: Border.all(
                                                    color: colors.accent
                                                        .withValues(
                                                            alpha: 0.18),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.drag_indicator_rounded,
                                                  size: 18,
                                                  color: colors.mutedText,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AccountDataCard(
                                              character: character,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                          orElse: () => Center(
                                child: Text(
                                  'Keine Daten vorhanden!',
                                  style: text.sectionSubtitle.copyWith(
                                    color: colors.mutedText,
                                  ),
                                ),
                              ));
                    },
                    listener: (context, state) {
                      state.whenOrNull(
                        failed: (errorMsg) async {
                          final result = await showDialog(
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
                          pageCubit.loadAccounts();
                        },
                      );
                    },
                  ),
                ))
          ],
        ));
  }
}
