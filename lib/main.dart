import 'package:flutter/material.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = SqfliteRepository();
  bool isDbInitialized = false;
  try {
    await database.initializeDatabase();
    isDbInitialized = true;
  } catch (e) {
    print('Error initializing database: $e');
  }
  runApp(MyApp(database: database, isDbInitialized: isDbInitialized));
}

class MyApp extends StatelessWidget {
  final SqfliteRepository? database;
  final bool isDbInitialized;

  const MyApp({Key? key, required this.database, required this.isDbInitialized}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wilks Calculator",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(database: database!, isDbInitialized: isDbInitialized),
    );
  }
}
