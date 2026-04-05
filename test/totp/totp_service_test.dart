import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/services/totp/totp_service.dart';

void main() {
  group('TotpService', () {
    test('generateCode returns expected code for fixed timestamp', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';
      final timestamp = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      /// Act
      final code = totpService.generateCode(
        secret: secret,
        timestamp: timestamp,
      );

      /// Assert
      expect(code, equals('282760'));
    });

    test('isCodeValid returns true for correct code at fixed timestamp', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';
      final timestamp = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      final code = totpService.generateCode(
        secret: secret,
        timestamp: timestamp,
      );

      /// Act
      final isValid = totpService.isCodeValid(
        secret: secret,
        code: code,
        timestamp: timestamp,
      );

      /// Assert
      expect(isValid, isTrue);
    });

    test('isCodeValid returns false for incorrect code at fixed timestamp', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';
      final timestamp = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      /// Act
      final isValid = totpService.isCodeValid(
        secret: secret,
        code: '000000',
        timestamp: timestamp,
      );

      /// Assert
      expect(isValid, isFalse);
    });

    test('isCodeValid returns true for code from previous time window', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';

      final baseTimestamp =
          DateTime.fromMillisecondsSinceEpoch(30000, isUtc: true);
      final previousTimestamp =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      final previousCode = totpService.generateCode(
        secret: secret,
        timestamp: previousTimestamp,
      );

      /// Act
      final isValid = totpService.isCodeValid(
        secret: secret,
        code: previousCode,
        timestamp: baseTimestamp,
      );

      /// Assert
      expect(isValid, isTrue);
    });

    test('isCodeValid returns true for code from next time window', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';

      final baseTimestamp = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final nextTimestamp =
          DateTime.fromMillisecondsSinceEpoch(30000, isUtc: true);

      final nextCode = totpService.generateCode(
        secret: secret,
        timestamp: nextTimestamp,
      );

      /// Act
      final isValid = totpService.isCodeValid(
        secret: secret,
        code: nextCode,
        timestamp: baseTimestamp,
      );

      /// Assert
      expect(isValid, isTrue);
    });

    test('generateCode throws ArgumentError for invalid Base32 secret', () {
      /// Arrange
      final totpService = TotpService();
      const invalidSecret = 'ABC123!!';

      /// Act & Assert
      expect(
        () => totpService.generateCode(
          secret: invalidSecret,
          timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('isCodeValid returns false for non-6-digit code format', () {
      /// Arrange
      final totpService = TotpService();
      const secret = 'JBSWY3DPEHPK3PXP';
      final timestamp = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      /// Act
      final isValid = totpService.isCodeValid(
        secret: secret,
        code: '12AB',
        timestamp: timestamp,
      );

      /// Assert
      expect(isValid, isFalse);
    });
  });
}
