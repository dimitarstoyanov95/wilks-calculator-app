import 'wilks_score.dart';

class Profile {
  final int? id;
  String firstName;
  String lastName;
  double age;
  String? username;
  String? password;
  List<WilksScore> myScores = [];

  Profile({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    this.username,
    this.password,
  });

  int? get getId => id;
  String get getFirstName => firstName;
  String get getLastName => lastName;
  double get getAge => age;
  String? get getUsername => username;
  String? get getPassword => password;
  List<WilksScore> get getMyScores => myScores;

  // Setters
  set setFirstName(String value) => firstName = value;
  set setLastName(String value) => lastName = value;
  set setAge(double value) => age = value;
  set setUsername(String? value) => username = value;
  set setPassword(String? value) => password = value;
  set setMyScores(List<WilksScore> value) => myScores = value;

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      age: map['age'],
      username: map['username'],
      password: map['password'],
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'username': username,
      'password': password,
    };
  }

    // Methods for adding/removing scores
  void addScore(WilksScore wilksScore) {
    myScores.add(wilksScore);
  }

  void removeScore(int? id) {
    myScores.removeWhere((score) => score.id == id);
  }
}
