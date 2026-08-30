import 'package:flutter/material.dart';
import 'app.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.instance.load();
  runApp(const GuessTApp());
}
