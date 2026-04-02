import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../../data/account.dart';
import '../../../../../helper/error_report_builder.dart';
import '../../../../../repository/credential_repository.dart';
import '../../../../../repository/error_report_repository.dart';
import '../../../../../repository/error_repository.dart';
import '../../../../../repository/main_repository.dart';
import '../../../../../repository/preferences_repository.dart';
import '../../../../../widgets/log.dart';

part 'account_add_page_state.dart';

part 'account_add_page_cubit.freezed.dart';

class AccountAddPageCubit extends Cubit<AccountAddPageState> {
  final MainRepository mainRepository;
  final PreferencesRepository preferencesRepository;

  AccountAddPageCubit({
    required this.mainRepository,
    required this.preferencesRepository,
  }) : super(const AccountAddPageState.initial());

  void initialize() {
    emit(const AccountAddPageState.initialized());
  }

  void changeVisibility(bool isVisible) {
    emit(AccountAddPageState.changeVisibility(isVisible: isVisible));
  }

  Future<void> addAccount(Account account, String passwd) async {
    emit(const AccountAddPageState.addingNewAccount());
    try {
      //generate uuid
      final uniqueId = const Uuid().v4();
      account.uniqueId = uniqueId;

      await Log.i('Adding account accId: ${account.accId}');
      final credentialRepository = CredentialRepository();

      final ids = <int>[];

      for (final a in mainRepository.accountList) {
        ids.add(a.accId);
      }

      await Log.i('Existing account IDs: $ids');
      if (ids.isNotEmpty) {
        ids.sort();
        final i = ids.last;
        account.accId = i + 1;
      }

      /// Save password securely in Windows Credential Manager first.
      await credentialRepository.savePassword(account.uniqueId, passwd);

      mainRepository.accountList.add(account);

      await Log.i(
          'Account added to MainRepository with accId: ${account.accId}, now saving accounts to PreferencesRepository');
      final accStringList = <String>[];

      for (final a in mainRepository.accountList) {
        final accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      await preferencesRepository.setAccounts(accStringList);

      await Log.i(
          'Account addition process completed successfully for accId: ${account.accId}');
      emit(const AccountAddPageState.accountAdded());
    } catch (e, st) {
      await Log.i('Error occurred while adding account: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );

      emit(AccountAddPageState.failed(errorMsg: e.toString()));
    }
  }

  Future<void> editAccount(Account account, String passwd) async {
    emit(const AccountAddPageState.addingNewAccount());
    try {
      await Log.i('Editing account accName: ${account.accountName}');
      final credentialRepository = CredentialRepository();
      await credentialRepository.savePassword(account.uniqueId, passwd);

      final index = mainRepository.accountList.indexWhere(
        (a) => a.uniqueId == account.uniqueId,
      );

      if (index == -1) {
        throw Exception('Account to edit was not found.');
      }

      mainRepository.accountList[index] = account;

      await Log.i(
          'Account edited to MainRepository with accName: ${account.accountName}, now saving accounts to PreferencesRepository');
      final accStringList = <String>[];

      for (final a in mainRepository.accountList) {
        final accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      await preferencesRepository.setAccounts(accStringList);
      mainRepository.account = null;
      emit(const AccountAddPageState.accountAdded());
    } catch (e, st) {
      await Log.i('Error occurred while editing account: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );
      emit(AccountAddPageState.failed(errorMsg: e.toString()));
    }
  }
}
