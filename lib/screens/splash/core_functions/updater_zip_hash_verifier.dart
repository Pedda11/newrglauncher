import 'dart:io';
import 'package:crypto/crypto.dart';
import '../../../widgets/log.dart';

class UpdaterZipHashVerifier {
  static Future<String> sha256File(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw StateError('File not found for hash: $path');
    }

    final digest = await sha256.bind(file.openRead()).first;
    return digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static Future<void> verify({
    required String filePath,
    required String expectedHex,
  }) async {
    final actual = await sha256File(filePath);

    if (actual.toLowerCase() != expectedHex.toLowerCase()) {
      await Log.i('Updater zip SHA256 mismatch. expected=$expectedHex');
      await Log.i('Actual hash: $actual');
      throw StateError(
        'Updater zip SHA256 mismatch. expected=$expectedHex actual=$actual',
      );
    }
  }
}
