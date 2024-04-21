import 'package:flutter/material.dart';
import 'package:wilks_calculator/application/authentication/signup.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';
import '../../domain/model/profile.dart';
import '../user/wilks_calculator_page.dart';

class LogInPage extends StatefulWidget {
  final SqfliteRepository database;

  const LogInPage({Key? key, required this.database}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late Profile loggedInUser;
  bool _showErrorMessage = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                errorText: _showErrorMessage ? "Incorrect username" : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                errorText: _showErrorMessage ? "Incorrect password" : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool isValidCredentials = await widget.database.authenticateUser(
                  _usernameController.text,
                  _passwordController.text,
                );

                if (isValidCredentials) {
                  loggedInUser = (await widget.database.getUserByUsername(_usernameController.text))!;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WilksCalculatorPage(database: widget.database, loggedInUser: loggedInUser)),
                  );
                } else {
                  setState(() {
                    _showErrorMessage = true;
                  });
                }
              },
              child: const Text("Log In"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage(database: widget.database)),
                );
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
