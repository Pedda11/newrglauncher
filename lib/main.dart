import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application.dart';
import 'widgets/repository_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = SharedPreferencesAsync();
  runApp(RepositoryContainer(
    sharedPreferences: sharedPreferences,
    child: Application(),
  ));
}
