// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountScreenNoAccounts":
            MessageLookupByLibrary.simpleMessage("No accounts saved"),
        "accountScreenNoData":
            MessageLookupByLibrary.simpleMessage("No data available"),
        "accountScreenTitle":
            MessageLookupByLibrary.simpleMessage("My Accounts"),
        "addAccountScreenAccountNameLabel":
            MessageLookupByLibrary.simpleMessage("Account Name"),
        "addAccountScreenListNameLabel":
            MessageLookupByLibrary.simpleMessage("List Name"),
        "addAccountScreenNewAccount":
            MessageLookupByLibrary.simpleMessage("New Account"),
        "addAccountScreenPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Account Password"),
        "addAccountScreenRealmLabel":
            MessageLookupByLibrary.simpleMessage("Realm/Logon Server"),
        "addAccountScreenTitle":
            MessageLookupByLibrary.simpleMessage("Add Account"),
        "appTitle": MessageLookupByLibrary.simpleMessage("WOW Launcher"),
        "loginScreenEnterPin":
            MessageLookupByLibrary.simpleMessage("Enter your PIN"),
        "loginScreenFirstLogin": MessageLookupByLibrary.simpleMessage(
            "This is your first login. Please create a 4-digit PIN."),
        "loginScreenHint": MessageLookupByLibrary.simpleMessage("PIN"),
        "loginScreenPinToShort":
            MessageLookupByLibrary.simpleMessage("Your PIN is too short"),
        "loginScreenPinsNotTheSame":
            MessageLookupByLibrary.simpleMessage("Your PINs do not match"),
        "loginScreenRepeatEnterPin":
            MessageLookupByLibrary.simpleMessage("Please repeat your PIN!"),
        "loginScreenTitle": MessageLookupByLibrary.simpleMessage("LOGIN"),
        "menuItemSettings": MessageLookupByLibrary.simpleMessage("Settings"),
        "menuTitle": MessageLookupByLibrary.simpleMessage("MENU"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "settingsScreenWowPath":
            MessageLookupByLibrary.simpleMessage("WoW Path"),
        "updateScreenUpdateFound":
            MessageLookupByLibrary.simpleMessage("UPDATE AVAILABLE"),
        "updateScreenUpdateFoundQuestion": MessageLookupByLibrary.simpleMessage(
            "A newer version is available. Do you want to update now?"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
