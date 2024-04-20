class WilksScore {
  final int? id;
  double bodyweight;
  double benchPress;
  double squat;
  double deadlift;
  double wilksScore;

  WilksScore({
    this.id,
    required this.bodyweight,
    required this.benchPress,
    required this.squat,
    required this.deadlift,
    required this.wilksScore,
  });

  // Getters
  int? get getId => id;
  double get getBodyweight => bodyweight;
  double get getBenchPress => benchPress;
  double get getSquat => squat;
  double get getDeadlift => deadlift;
  double get getWilksScore => wilksScore;

  // Setters
  set setBodyweight(double value) => bodyweight = value;
  set setBenchPress(double value) => benchPress = value;
  set setSquat(double value) => squat = value;
  set setDeadlift(double value) => deadlift = value;
  set setWilksScore(double value) => wilksScore = value;

  factory WilksScore.fromMap(Map<String, dynamic> map) {
    return WilksScore(
      id: map['id'],
      bodyweight: map['bodyweight'],
      benchPress: map['benchPress'],
      squat: map['squat'],
      deadlift: map['deadlift'],
      wilksScore: map['wilksScore'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bodyweight': bodyweight,
      'benchPress': benchPress,
      'squat': squat,
      'deadlift': deadlift,
      'wilksScore': wilksScore,
    };
  }
}
