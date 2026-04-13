import 'dart:convert';

class LauncherPinData {
  final String salt;
  final String hash;

  const LauncherPinData({
    required this.salt,
    required this.hash,
  });

  factory LauncherPinData.fromJson(Map<String, dynamic> json) {
    return LauncherPinData(
      salt: json['salt'] as String,
      hash: json['hash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salt': salt,
      'hash': hash,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory LauncherPinData.fromRawJson(String rawJson) {
    return LauncherPinData.fromJson(
      jsonDecode(rawJson) as Map<String, dynamic>,
    );
  }
}
