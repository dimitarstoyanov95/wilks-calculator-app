import 'package:flutter/material.dart';
import 'package:wilks_calculator/domain/model/profile.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';

class SignUpPage extends StatefulWidget {
  final SqfliteRepository database;

  const SignUpPage({Key? key, required this.database}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: "Age",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    void _showErrorMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    // Check if all fields are filled
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Create a new Profile object
      Profile newProfile = Profile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: double.parse(_ageController.text),
        username: _usernameController.text,
        password: _passwordController.text,
      );
      widget.database.createProfile(newProfile);

      Navigator.pop(context);
    } else {
      setState(() {
        _showErrorMessage('Please fill in all fields.');
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
