import 'dart:convert';

import 'package:http/http.dart' as http;

class ErrorReportRepository {
  Future<bool> uploadErrorReport({
    required String app,
    required String report,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.pedda.tech/upload-log'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'app': app,
          'report': report,
        }),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      /// Never crash because log upload failed.
      return false;
    }
  }
}
