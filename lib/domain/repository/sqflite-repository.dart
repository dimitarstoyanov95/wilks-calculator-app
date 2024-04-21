import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/profile.dart';
import '../model/wilks_score.dart';

class SqfliteRepository {
  static const String dbName = 'wilks_calculator.db';
  static const String profileTable = 'profiles';
  static const String scoreTable = 'scores';
  static const String loggedInUserTable = 'loggedInUser';

  late Database _database;

 Future<Database> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: 1,
      onCreate: _onCreate,
    );
    return _database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $profileTable (
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            age REAL,
            username TEXT, -- Add UNIQUE constraint to username
            password TEXT -- Add UNIQUE constraint to password
          )
        ''');
    await db.execute('''
          CREATE TABLE $scoreTable (
            id INTEGER PRIMARY KEY,
            bodyweight REAL,
            benchPress REAL,
            squat REAL,
            deadlift REAL,
            wilksScore REAL,
            profileId INTEGER,
            FOREIGN KEY (profileId) REFERENCES $profileTable(id)
          )
        ''');
  }

  Future<void> createProfile(Profile profile) async {
    await _database.insert(
      profileTable,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> createWilksScore(WilksScore score) async {
  await _database.insert(
    scoreTable,
    score.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

  Future<List<WilksScore>> getScoresForProfile(int profileId) async {
  final List<Map<String, dynamic>> maps = await _database.query(
    scoreTable,
    where: 'profileId = ?',
    whereArgs: [profileId],
  );
  return List.generate(maps.length, (i) {
    return WilksScore.fromMap(maps[i]);
  });
}

  Future<void> deleteProfile(String username) async {
    await _database.delete(
      profileTable,
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<void> deleteWilksScore(int id) async {
    await _database.delete(
      scoreTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> authenticateUser(String username, String password) async {
    final List<Map<String, dynamic>> result = await _database.query(
      profileTable,
      columns: ['id'],
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  Future<Profile?> update(Profile updatedProfile, String username) async {
  final int rowsAffected = await _database.update(
    profileTable,
    updatedProfile.toMap(),
    where: 'username = ?',
    whereArgs: [username],
  );

  if (rowsAffected > 0) {
    return updatedProfile;
  } else {
    return null;
  }
}

  Future<Profile?> getUserByUsername(String username) async {
  final List<Map<String, dynamic>> maps = await _database.query(
    profileTable,
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (maps.isNotEmpty) {
    return Profile.fromMap(maps[0]);
  }
  return null;
}
}
