import 'dart:convert';

/// Function to parse JSON data into a List of User objects.
/// final users = userFromJson(jsonString);
List<Account> userFromJson(String str) =>
    List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));

/// Function to convert a List of User objects to a JSON string.
/// String jsonString = userToJson(users);
String userToJson(List<Account> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Account {
  int accId;
  String listName;
  String accountName;
  String accountPassword;
  String accountRealm;
  List<dynamic>? accChars;

  Account({
    required this.accId,
    required this.listName,
    required this.accountName,
    required this.accountPassword,
    required this.accountRealm,
    required this.accChars,
  });

  /// Factory method to create a User object from a JSON map.
  factory Account.fromJson(Map<String, dynamic> json) => Account(
        accId: json["accId"],
        listName: json["listName"],
        accountName: json["accountName"],
        accountPassword: json["accountPassword"],
        accountRealm: json["accountRealm"],
        accChars: json["accChars"],
      );

  /// Convert the User object to a JSON map.
  Map<String, dynamic> toJson() => {
        "accId": accId,
        "listName": listName,
        "accountName": accountName,
        "accountPassword": accountPassword,
        "accountRealm": accountRealm,
        "accChars": accChars,
      };
}
