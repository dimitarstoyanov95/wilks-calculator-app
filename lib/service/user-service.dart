import '../domain/model/profile.dart';
import '../domain/repository/sqflite-repository.dart';

class UserService {

  final SqfliteRepository _databaseService;

  UserService(this._databaseService);

  Future<void> create(Profile profile) async {
    await _databaseService.createProfile(profile);
  }

  Future<void> deleteByUsername(String username) async {
    await _databaseService.deleteProfile(username);
  }

  Future<bool> authenticateUser(String username, String password) async {
    return await _databaseService.authenticateUser(username, password);
  }

  Future<Profile?> update(Profile updatedProfile, String username) async {
    return await _databaseService.update(updatedProfile, username);
  }

  Future<Profile?> getByUsername(String username) async {
    return await _databaseService.getUserByUsername(username);
  }
}
