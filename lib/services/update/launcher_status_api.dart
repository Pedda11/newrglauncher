import 'package:http/http.dart' as http;

import '../../data/launcher_status_data.dart';

class LauncherStatusApi {
  final Uri statusUri;

  LauncherStatusApi(this.statusUri);

  Future<LauncherStatusData> fetchStatus() async {
    /// Fetch launcher status from your backend.
    final res = await http.get(
      statusUri,
      headers: {
        'Accept': 'application/json',

        /// Prevent proxies from caching status responses
        'Cache-Control': 'no-cache',
      },
    ).timeout(const Duration(seconds: 5));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Status API failed: ${res.statusCode} ${res.body}');
    }

    return LauncherStatusData.parse(res.body);
  }
}
