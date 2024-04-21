import 'package:flutter/material.dart';
import 'package:wilks_calculator/domain/model/profile.dart';
import '../../domain/model/wilks_score.dart';
import '../../domain/repository/sqflite-repository.dart';
import 'profile_page.dart';

class WilksCalculatorPage extends StatefulWidget {
  final SqfliteRepository database;
  final Profile loggedInUser;

  const WilksCalculatorPage({Key? key, required this.database, required this.loggedInUser}) : super(key: key);

  @override
  State<WilksCalculatorPage> createState() => _WilksCalculatorPageState();
}

class _WilksCalculatorPageState extends State<WilksCalculatorPage> {
  late WilksScore score;
  bool showSaveButton = false;

  @override
  void initState() {
    super.initState();
    score = WilksScore(
      profileId: widget.loggedInUser.getId!,
      bodyweight: 0,
      benchPress: 0,
      squat: 0,
      deadlift: 0,
      wilksScore: 0,
    );
  }

  void calculateWilksScore() {
    const a = -216.0475144;
    const b = 16.2606339;
    const c = -0.002388645;
    const d = -0.00113732;
    const e = 7.01863E-06;
    const f = -1.291E-08;

    final total = score.benchPress + score.deadlift + score.squat;
    final coefficient = 500 /
        (a +
            b * score.bodyweight +
            c * score.bodyweight * score.bodyweight +
            d * score.bodyweight * score.bodyweight * score.bodyweight +
            e * score.bodyweight * score.bodyweight * score.bodyweight * score.bodyweight +
            f * score.bodyweight * score.bodyweight * score.bodyweight * score.bodyweight * score.bodyweight);

    score.wilksScore = total * coefficient;

    setState(() {
      showSaveButton = true;
    });
  }

  void saveScore() async {
    // Save the score to the database
    await widget.database.createWilksScore(score);

    // Hide the save button after saving the score
    setState(() {
      showSaveButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wilks Calculator", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(database: widget.database, loggedInUser: widget.loggedInUser)),
                  );
                },
                child: const Text("My Profile"),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: "Bodyweight (kg)"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  score.bodyweight = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: "Bench Press (kg)"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  score.benchPress = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: "Squat (kg)"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  score.squat = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: "Deadlift (kg)"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  score.deadlift = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateWilksScore,
                child: const Text("Calculate Wilks Score"),
              ),
              if (showSaveButton) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveScore,
                  child: const Text("Save Score"),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                "Wilks Score: ${score.wilksScore}",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              _buildScoreBoard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    int userWilksScore = score.wilksScore.toInt();
    String userLifterType = _getLifterType(userWilksScore);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildScoreRow("Beginner", 120),
        _buildScoreRow("Novice", 200),
        _buildScoreRow("Intermediate", 238),
        _buildScoreRow("Advanced", 326),
        _buildScoreRow("Elite", 414),
        const SizedBox(height: 16),
        Text(
          "Status - $userLifterType",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScoreRow(String level, int wilksScore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(level),
        Text(wilksScore.toString()),
      ],
    );
  }

  String _getLifterType(int wilksScore) {
    if (wilksScore < 120) {
      return "Beginner";
    } else if (wilksScore < 200) {
      return "Novice";
    } else if (wilksScore < 238) {
      return "Intermediate";
    } else if (wilksScore < 326) {
      return "Advanced";
    } else {
      return "Elite";
    }
  }
}
