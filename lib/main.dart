import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';

import 'screens/home_screen.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    await HiveService.init();
    debugPrint('WorkRecordAdapter registered: ${Hive.isAdapterRegistered(0)}');
    debugPrint('WorkTypeAdapter registered: ${Hive.isAdapterRegistered(1)}');

    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e, s) {
    debugPrint('Ошибка запуска: $e');
    debugPrint('Stack trace: $s');

    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Ошибка запуска: $e'))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Учет рабочего времени',
          theme: getLightTheme(),
          darkTheme: getDarkTheme(),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
