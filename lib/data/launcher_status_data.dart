import 'dart:convert';

class LauncherStatusData {
  final bool maintenance;
  final String launcherVersion;
  final String updaterVersion;

  final String? motd;
  final String? imageUrl;
  final UpdateData? update;
  final UpdateData? updaterUpdate;

  LauncherStatusData({
    required this.maintenance,
    required this.launcherVersion,
    required this.updaterVersion,
    this.motd,
    this.imageUrl,
    this.update,
    this.updaterUpdate,
  });

  factory LauncherStatusData.fromJson(Map<String, dynamic> json) {
    final maintenance = json['maintenance'];
    final launcherVersion = json['launcherVersion'];
    final updaterVersion = json['updaterVersion'];

    if (maintenance is! bool) {
      throw const FormatException('maintenance missing or not bool');
    }

    if (launcherVersion is! String || launcherVersion.isEmpty) {
      throw const FormatException('launcherVersion missing or not string');
    }

    if (updaterVersion is! String || updaterVersion.isEmpty) {
      throw const FormatException('updaterVersion missing or not string');
    }

    final motd = json['motd'] as String?;
    final imageUrl = json['imageUrl'] as String?;
    final updateJson = json['update'] as Map<String, dynamic>?;
    final updaterUpdateJson = json['updaterUpdate'] as Map<String, dynamic>?;

    return LauncherStatusData(
      maintenance: maintenance,
      launcherVersion: launcherVersion,
      updaterVersion: updaterVersion,
      motd: motd,
      imageUrl: imageUrl,
      update: updateJson == null ? null : UpdateData.fromJson(updateJson),
      updaterUpdate: updaterUpdateJson == null
          ? null
          : UpdateData.fromJson(updaterUpdateJson),
    );
  }

  static LauncherStatusData parse(String body) {
    final map = jsonDecode(body) as Map<String, dynamic>;
    return LauncherStatusData.fromJson(map);
  }
}

class UpdateData {
  final String url;
  final String sha256;

  UpdateData({
    required this.url,
    required this.sha256,
  });

  factory UpdateData.fromJson(Map<String, dynamic> json) {
    final url = json['url'];
    final sha256 = json['sha256'];

    if (url is! String || url.isEmpty) {
      throw const FormatException('update.url missing or not string');
    }

    if (sha256 is! String || sha256.isEmpty) {
      throw const FormatException('update.sha256 missing or not string');
    }

    return UpdateData(
      url: url,
      sha256: sha256,
    );
  }
}
