import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'i_totp_service.dart';

class TotpService implements ITotpService {
  static const int _interval = 30; // seconds
  static const int _digits = 6;

  @override
  String generateCode({
    required String secret,
    DateTime? timestamp,
  }) {
    final time = timestamp ?? DateTime.now().toUtc();
    final counter = time.millisecondsSinceEpoch ~/ 1000 ~/ _interval;

    final key = _base32Decode(secret);
    final counterBytes = _intToBytes(counter);

    final hmac = Hmac(sha1, key);
    final hash = hmac.convert(counterBytes).bytes;

    final offset = hash.last & 0x0F;

    final binary = ((hash[offset] & 0x7F) << 24) |
        ((hash[offset + 1] & 0xFF) << 16) |
        ((hash[offset + 2] & 0xFF) << 8) |
        (hash[offset + 3] & 0xFF);

    final otp = binary % _pow10(_digits);

    return otp.toString().padLeft(_digits, '0');
  }

  @override
  bool isCodeValid({
    required String secret,
    required String code,
    DateTime? timestamp,
  }) {
    final normalizedCode = code.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(normalizedCode)) {
      return false;
    }

    final baseTime = timestamp ?? DateTime.now().toUtc();

    for (var offset = -1; offset <= 1; offset++) {
      final testTime = baseTime.add(Duration(seconds: offset * 30));
      final generatedCode = generateCode(
        secret: secret,
        timestamp: testTime,
      );

      if (generatedCode == normalizedCode) {
        return true;
      }
    }

    return false;
  }

  int getSecondsRemaining() {
    final now = DateTime.now().toUtc();
    final seconds = now.millisecondsSinceEpoch ~/ 1000;
    return 30 - (seconds % 30);
  }

  Uint8List _intToBytes(int value) {
    final bytes = Uint8List(8);

    for (var i = 7; i >= 0; i--) {
      bytes[i] = value & 0xFF;
      value = value >> 8;
    }

    return bytes;
  }

  int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  Uint8List _base32Decode(String input) {
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    final cleaned = input.replaceAll('=', '').toUpperCase();

    final bytes = <int>[];
    var buffer = 0;
    var bitsLeft = 0;

    for (final char in cleaned.split('')) {
      final val = base32Chars.indexOf(char);

      if (val == -1) {
        throw ArgumentError('Invalid Base32 character: $char');
      }

      buffer = (buffer << 5) | val;
      bitsLeft += 5;

      if (bitsLeft >= 8) {
        bytes.add((buffer >> (bitsLeft - 8)) & 0xFF);
        bitsLeft -= 8;
      }
    }

    return Uint8List.fromList(bytes);
  }
}
