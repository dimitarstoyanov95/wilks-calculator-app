import 'package:flutter/material.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';
import '../../domain/model/profile.dart';

class ProfilePage extends StatefulWidget {
  final SqfliteRepository database;

  const ProfilePage({Key? key, required this.database}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Profile? loggedInUser;

  @override
  void initState() {
    super.initState();
    loggedInUser = widget.database.getLoggedInProfile() as Profile?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 50,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "User Info",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text("First Name: ${loggedInUser?.firstName ?? ''}"),
            Text("Last Name: ${loggedInUser?.lastName ?? ''}"),
            Text("Age: ${loggedInUser?.age ?? ''}"),
            const SizedBox(height: 16),
            Text(
              "My Scores",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: loggedInUser?.myScores.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: Text("Score ${index}"),
                        subtitle: Text(
                          "Bodyweight: ${loggedInUser?.myScores[index].bodyweight}, Bench Press: ${loggedInUser?.myScores[index].benchPress}, Squat: ${loggedInUser?.myScores[index].squat}, Deadlift: ${loggedInUser?.myScores[index].deadlift}, Wilks Score: ${loggedInUser?.myScores[index].wilksScore}",
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Remove the score from the database
                      //     setState(() {
                      //       loggedInUser?.myScores.removeAt(index);
                      //     });
                      //     widget.dbHelper.deleteWilksScore(
                      //         loggedInUser?.myScores[index].getId);
                      //   },
                      //   child: const Text("Delete"),
                      // ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
