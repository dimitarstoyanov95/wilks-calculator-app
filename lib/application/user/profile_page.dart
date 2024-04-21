import 'package:flutter/material.dart';
import 'package:wilks_calculator/domain/repository/sqflite-repository.dart';
import '../../domain/model/profile.dart';
import '../../domain/model/wilks_score.dart';

class ProfilePage extends StatefulWidget {
  final SqfliteRepository database;
  final Profile loggedInUser;

  const ProfilePage({Key? key, required this.database, required this.loggedInUser}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<WilksScore> myScores;

  @override
  void initState() {
    super.initState();
    fetchScoresForProfile(widget.loggedInUser.getId!);
  }

  Future<void> fetchScoresForProfile(int profileId) async {
    List<WilksScore> scores = await widget.database.getScoresForProfile(profileId);
    setState(() {
      myScores = scores;
    });
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
            const SizedBox(height: 16),
            Text(
              "User Info",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text("First Name: ${widget.loggedInUser.firstName}"),
            Text("Last Name: ${widget.loggedInUser.lastName}"),
            Text("Age: ${widget.loggedInUser.age}"),
            const SizedBox(height: 16),
            Text(
              "My Scores",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: myScores.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: Text("Score ${index + 1}"),
                        subtitle: Text(
                          "Bodyweight: ${myScores[index].bodyweight}, Bench Press: ${myScores[index].benchPress}, Squat: ${myScores[index].squat}, Deadlift: ${myScores[index].deadlift}, Wilks Score: ${myScores[index].wilksScore}",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.database.deleteWilksScore(myScores[index].getId!);
                          fetchScoresForProfile(widget.loggedInUser.getId!);
                        },
                        child: const Text("Delete"),
                      ),
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
