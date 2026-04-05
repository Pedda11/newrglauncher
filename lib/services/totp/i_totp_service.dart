abstract interface class ITotpService {
  String generateCode({
    required String secret,
    DateTime? timestamp,
  });

  bool isCodeValid({
    required String secret,
    required String code,
    DateTime? timestamp,
  });

  int getSecondsRemaining() {
    final now = DateTime.now().toUtc();
    final seconds = now.millisecondsSinceEpoch ~/ 1000;
    return 30 - (seconds % 30);
  }
}
