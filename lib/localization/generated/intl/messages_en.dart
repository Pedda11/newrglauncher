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

  static String m0(message) => "blocking error: ${message}";

  static String m1(message) => "update required: ${message}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept": MessageLookupByLibrary.simpleMessage("accept"),
    "accountAddPageAccountNameHint": MessageLookupByLibrary.simpleMessage(
      "Account Name",
    ),
    "accountAddPageAccountNameLabel": MessageLookupByLibrary.simpleMessage(
      "Account Name",
    ),
    "accountAddPageBackButton": MessageLookupByLibrary.simpleMessage("Back"),
    "accountAddPageListNameHint": MessageLookupByLibrary.simpleMessage(
      "List Name",
    ),
    "accountAddPageListNameLabel": MessageLookupByLibrary.simpleMessage(
      "List Name",
    ),
    "accountAddPageNewAccount": MessageLookupByLibrary.simpleMessage(
      "N e w   A c c o u n t",
    ),
    "accountAddPagePasswordHint": MessageLookupByLibrary.simpleMessage(
      "Account Password",
    ),
    "accountAddPagePasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Account Password",
    ),
    "accountAddPageRealmLabel": MessageLookupByLibrary.simpleMessage(
      "Realm/Logon Server",
    ),
    "accountAddPageSaveButton": MessageLookupByLibrary.simpleMessage("Save"),
    "accountAddPageTitle": MessageLookupByLibrary.simpleMessage("Add Account"),
    "accountDataCardClassLabel": MessageLookupByLibrary.simpleMessage(
      "Class: ",
    ),
    "accountDataCardFactionLabel": MessageLookupByLibrary.simpleMessage(
      "Faction: ",
    ),
    "accountDataCardGoldLabel": MessageLookupByLibrary.simpleMessage("Gold: "),
    "accountDataCardGuild": MessageLookupByLibrary.simpleMessage("Guild"),
    "accountDataCardGuildLabel": MessageLookupByLibrary.simpleMessage(
      "Guild: ",
    ),
    "accountDataCardInstancesTitle": MessageLookupByLibrary.simpleMessage(
      "IDs",
    ),
    "accountDataCardLastLogoutLabel": MessageLookupByLibrary.simpleMessage(
      "Last Logout: ",
    ),
    "accountDataCardNameLabel": MessageLookupByLibrary.simpleMessage("Name: "),
    "accountDataCardNoData": MessageLookupByLibrary.simpleMessage(
      "No data available!",
    ),
    "accountDataCardNoGuild": MessageLookupByLibrary.simpleMessage("No "),
    "accountDataCardNullValue": MessageLookupByLibrary.simpleMessage("NULL"),
    "accountDataCardZoneLabel": MessageLookupByLibrary.simpleMessage("Zone: "),
    "accountListPageAddAccountBtn": MessageLookupByLibrary.simpleMessage(
      "Add Account",
    ),
    "accountListPageTitle": MessageLookupByLibrary.simpleMessage(
      "Account List",
    ),
    "accountScreenNoAccounts": MessageLookupByLibrary.simpleMessage(
      "No accounts saved",
    ),
    "accountScreenNoData": MessageLookupByLibrary.simpleMessage(
      "No data available",
    ),
    "accountScreenResetButton": MessageLookupByLibrary.simpleMessage("reset"),
    "accountScreenTitle": MessageLookupByLibrary.simpleMessage("My Accounts"),
    "appTitle": MessageLookupByLibrary.simpleMessage("WOW-Launcher"),
    "back": MessageLookupByLibrary.simpleMessage("back"),
    "decline": MessageLookupByLibrary.simpleMessage("decline"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorHandlingContent": MessageLookupByLibrary.simpleMessage(
      "The following error occurred. The error will be reported automatically. Please try again later.",
    ),
    "eulaAcceptText": MessageLookupByLibrary.simpleMessage(
      "I have read and accept the Eula",
    ),
    "eulaLabel": MessageLookupByLibrary.simpleMessage("Eula"),
    "menuItemSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "menuTitle": MessageLookupByLibrary.simpleMessage("M E N U"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "settingsScreenCancelWowScanLabel": MessageLookupByLibrary.simpleMessage(
      "Stop scan",
    ),
    "settingsScreenDriveAccessError": MessageLookupByLibrary.simpleMessage(
      "Could not access drive ",
    ),
    "settingsScreenFoundWowExesLabel": MessageLookupByLibrary.simpleMessage(
      "Found the following wow.exe files.",
    ),
    "settingsScreenNotAllSet": MessageLookupByLibrary.simpleMessage(
      "Not all settings set yet!",
    ),
    "settingsScreenScannedFiles": MessageLookupByLibrary.simpleMessage(
      "Scanned Files: ",
    ),
    "settingsScreenScannedFolders": MessageLookupByLibrary.simpleMessage(
      "Scanned Folder: ",
    ),
    "settingsScreenScanningForDrives": MessageLookupByLibrary.simpleMessage(
      "Scanning for Drives...",
    ),
    "settingsScreenSetWowPathLabel": MessageLookupByLibrary.simpleMessage(
      "Set the Wow Path by scanning your drives or selecting the file manually.",
    ),
    "settingsScreenSetWowPathManuallyDriveException":
        MessageLookupByLibrary.simpleMessage("Drive not available"),
    "settingsScreenTimeTillGameStartLabel":
        MessageLookupByLibrary.simpleMessage(
          "Estimated time until the launcher can enter the login details.",
        ),
    "settingsScreenTimeTillGameStartMissingLabel":
        MessageLookupByLibrary.simpleMessage(
          "Estimated time until game start missing",
        ),
    "settingsScreenTimeTillGameStartType": MessageLookupByLibrary.simpleMessage(
      "Seconds",
    ),
    "settingsScreenTitle": MessageLookupByLibrary.simpleMessage(
      "S E T T I N G S",
    ),
    "settingsScreenWowDataPathHint": MessageLookupByLibrary.simpleMessage(
      "Do you prefer to play WoW in German or English? Select the data folder corresponding to your language.",
    ),
    "settingsScreenWowDataPathLabel": MessageLookupByLibrary.simpleMessage(
      "Choose your Data Folder",
    ),
    "settingsScreenWowExeFilePickerLabel": MessageLookupByLibrary.simpleMessage(
      "Select your WoW executable",
    ),
    "settingsScreenWowPathDrivesBtnHint": MessageLookupByLibrary.simpleMessage(
      "<- Or manually select the application from one of the available drives.",
    ),
    "settingsScreenWowPathLabel": MessageLookupByLibrary.simpleMessage(
      "WoW Location",
    ),
    "settingsScreenWowPathMissingLabel": MessageLookupByLibrary.simpleMessage(
      "WoW Path not set yet",
    ),
    "settingsScreenWowPathScanBtn": MessageLookupByLibrary.simpleMessage(
      "Scan your system for wow.exe",
    ),
    "settingsScreenWowPathScanBtnHint": MessageLookupByLibrary.simpleMessage(
      "<- Scan your drives for wow.exe and select it from the shown list.",
    ),
    "splashScreenBlockingError": m0,
    "splashScreenEulaNotAccepted": MessageLookupByLibrary.simpleMessage(
      "Eula not accepted",
    ),
    "splashScreenInitialized": MessageLookupByLibrary.simpleMessage(
      "initialized",
    ),
    "splashScreenInitializedFirstStart": MessageLookupByLibrary.simpleMessage(
      "initialized first start",
    ),
    "splashScreenMaintenance": MessageLookupByLibrary.simpleMessage(
      "maintenance",
    ),
    "splashScreenUpdateRequired": m1,
    "updateScreenUpdateCheck": MessageLookupByLibrary.simpleMessage(
      "Checking for updates...",
    ),
    "updateScreenUpdateFound": MessageLookupByLibrary.simpleMessage(
      "U P D A T E   A V A I L A B L E",
    ),
    "updateScreenUpdateQuestion": MessageLookupByLibrary.simpleMessage(
      "Do you want to download and install the update now?",
    ),
    "updateScreenUpdating": MessageLookupByLibrary.simpleMessage(
      "Downloading and installing update!",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
