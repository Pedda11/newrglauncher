import 'dart:convert';

class LauncherStatusData {
  final bool maintenance;

  /// The single authoritative launcher version on the server.
  final String launcherVersion;

  final String? motd;
  final BannerData? banner;
  final LinksData? links;
  final LauncherError? error;

  LauncherStatusData({
    required this.maintenance,
    required this.launcherVersion,
    this.motd,
    this.banner,
    this.links,
    this.error,
  });

  factory LauncherStatusData.fromJson(Map<String, dynamic> json) {
    /// Required fields
    final maintenance = json['maintenance'];
    final launcherV = json['launcherVersion'];

    if (maintenance is! bool) {
      throw const FormatException('maintenance missing or not bool');
    }
    if (launcherV is! String || launcherV.isEmpty) {
      throw const FormatException('launcherVersion missing or not string');
    }

    /// Optional fields
    final motd = json['motd'] as String?;
    final bannerJson = json['banner'] as Map<String, dynamic>?;
    final linksJson = json['links'] as Map<String, dynamic>?;
    final errorJson = json['error'] as Map<String, dynamic>?;

    return LauncherStatusData(
      maintenance: maintenance,
      launcherVersion: launcherV,
      motd: motd,
      banner: bannerJson == null ? null : BannerData.fromJson(bannerJson),
      links: linksJson == null ? null : LinksData.fromJson(linksJson),
      error: errorJson == null ? null : LauncherError.fromJson(errorJson),
    );
  }

  static LauncherStatusData parse(String body) {
    final map = jsonDecode(body) as Map<String, dynamic>;
    return LauncherStatusData.fromJson(map);
  }
}

class BannerData {
  final String? url;
  final String? clickUrl;

  BannerData({this.url, this.clickUrl});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      url: json['url'] as String?,
      clickUrl: json['clickUrl'] as String?,
    );
  }
}

class LinksData {
  final String? discord;
  final String? website;
  final String? patchNotes;

  LinksData({this.discord, this.website, this.patchNotes});

  factory LinksData.fromJson(Map<String, dynamic> json) {
    return LinksData(
      discord: json['discord'] as String?,
      website: json['website'] as String?,
      patchNotes: json['patchNotes'] as String?,
    );
  }
}

class LauncherError {
  final String? code;
  final String? message;
  final bool? blocking;

  LauncherError({this.code, this.message, this.blocking});

  factory LauncherError.fromJson(Map<String, dynamic> json) {
    return LauncherError(
      code: json['code'] as String?,
      message: json['message'] as String?,
      blocking: json['blocking'] as bool?,
    );
  }
}
