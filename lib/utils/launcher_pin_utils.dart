import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../data/launcher_pin_data.dart';
import '../repository/credential_repository.dart';

class LauncherPinUtils {
  final CredentialRepository credentialRepository;

  LauncherPinUtils({required this.credentialRepository});

  Future<bool> hasLauncherPin() async {
    final rawPinData = await credentialRepository.readLauncherPin();
    return rawPinData != null && rawPinData.trim().isNotEmpty;
  }

  Future<bool> verifyLauncherPin(String pinString) async {
    final normalizedPin = pinString.trim();

    if (!RegExp(r'^\d{4}$').hasMatch(normalizedPin)) {
      return false;
    }

    final rawPinData = await credentialRepository.readLauncherPin();

    if (rawPinData == null || rawPinData.trim().isEmpty) {
      return false;
    }

    final pinData = LauncherPinData.fromRawJson(rawPinData);

    final hashInput = utf8.encode('$normalizedPin:${pinData.salt}');
    final hashBytes = sha256.convert(hashInput).bytes;
    final hashBase64 = base64Encode(hashBytes);

    return hashBase64 == pinData.hash;
  }
}
