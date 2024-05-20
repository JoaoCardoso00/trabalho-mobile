import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MyApp(settingsController: settingsController),
    ),
  );
}
