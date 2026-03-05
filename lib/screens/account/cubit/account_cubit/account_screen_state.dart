part of 'account_screen_cubit.dart';

@freezed
class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState.initial() = _initial;

  const factory AccountScreenState.initialized() = _initialized;

  const factory AccountScreenState.accountAdded() = _accountAdded;

  const factory AccountScreenState.deletingAccount() = _deletingAccount;

  const factory AccountScreenState.goToAddAccountPage() = _goToAddAccountPage;

  const factory AccountScreenState.failed({required String errorMsg}) = _failed;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode toDiagnosticsNode({name, DiagnosticsTreeStyle? style}) {
    // TODO: implement toDiagnosticsNode
    throw UnimplementedError();
  }

  @override
  String toStringDeep(
      {String prefixLineOne = '',
      String? prefixOtherLines,
      DiagnosticLevel minLevel = DiagnosticLevel.debug,
      int wrapWidth = 65}) {
    // TODO: implement toStringDeep
    throw UnimplementedError();
  }

  @override
  String toStringShallow(
      {String joiner = ', ',
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
    throw UnimplementedError();
  }

  @override
  String toStringShort() {
    // TODO: implement toStringShort
    throw UnimplementedError();
  }
}
