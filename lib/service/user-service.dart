import '../domain/model/profile.dart';
import '../domain/repository/sqflite-repository.dart';

class UserService {

  final SqfliteRepository _databaseService;

  UserService(this._databaseService);

  Future<void> createProfile(Profile profile) async {
    await _databaseService.createProfile(profile);
  }

  Future<List<Profile>> getProfiles() async {
    return await _databaseService.getProfiles();
  }

  Future<void> deleteProfile(int id) async {
    await _databaseService.deleteProfile(id);
  }

  Future<bool> authenticateUser(String username, String password) async {
    return await _databaseService.authenticateUser(username, password);
  }

  Future<void> setLoggedInProfile(int userId) async {
    await _databaseService.setLoggedInProfile(userId);
  }

  Future<Profile?> getLoggedInProfile() async {
    return await _databaseService.getLoggedInProfile();
  }
}
