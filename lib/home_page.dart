import 'package:flutter/material.dart';
import 'package:wilks_calculator/application/authentication/login.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';

class HomePage extends StatelessWidget {
  final SqfliteRepository database;
  final bool isDbInitialized;

  const HomePage({Key? key, required this.database, required this.isDbInitialized}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Wilks Calculator",
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage(database: database)),
                );
              },
              child: const Text("Calculate"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !isDbInitialized
          ? const BottomAppBar(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Database connection not available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
