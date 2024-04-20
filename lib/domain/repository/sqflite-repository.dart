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
            username TEXT,
            password TEXT
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
    await db.execute('''
          CREATE TABLE $loggedInUserTable (
            userId INTEGER PRIMARY KEY
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

  Future<List<Profile>> getProfiles() async {
    final List<Map<String, dynamic>> maps = await _database.query(profileTable);
    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }

  // Similar methods for updating and deleting profiles

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

  Future<void> deleteProfile(int id) async {
    await _database.delete(
      profileTable,
      where: 'id = ?',
      whereArgs: [id],
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

  Future<void> setLoggedInProfile(int userId) async {
    await _database.delete(loggedInUserTable);
    await _database.insert(loggedInUserTable, {'userId': userId});
  }

  Future<Profile?> getLoggedInProfile() async {
    final List<Map<String, dynamic>> result = await _database.query(
      loggedInUserTable,
      limit: 1,
    );

    if (result.isNotEmpty) {
      final int userId = result[0]['userId'];
      final List<Map<String, dynamic>> profileResult = await _database.query(
        profileTable,
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (profileResult.isNotEmpty) {
        return Profile.fromMap(profileResult[0]);
      }
    }
    return null;
  }
}
