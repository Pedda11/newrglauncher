import '../enum/e_startup_decision_type.dart';
import 'launcher_status_data.dart';

class StartupDecision {
  final EStartupDecisionType type;
  final LauncherStatusData status;
  final String? message;

  StartupDecision({
    required this.type,
    required this.status,
    this.message,
  });
}
