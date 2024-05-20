import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_hamburgueria_view.dart';
import 'auth/auth.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'login_view.dart';
import 'register_view.dart';
import 'settings/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hamburguerias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SampleItemListView(),
        '/sample_item': (context) => SampleItemDetailsView(),
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(), // Adiciona esta linha
        '/add_hamburgeria': (context) => AddHamburgeriaView(),
      },
    );
  }
}
