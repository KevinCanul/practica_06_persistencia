import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

import 'database/db.dart';
import 'screens/tareas_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  await DB.database;

  runApp(const PracticaApp());
}

class PracticaApp extends StatelessWidget {
  const PracticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TareasScreen(),
    );
  }
}
