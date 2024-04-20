import '../domain/model/wilks_score.dart';
import '../domain/repository/sqflite-repository.dart';

class WilksCalculatorService {
  final SqfliteRepository _databaseService;

  WilksCalculatorService(this._databaseService);

  Future<void> createWilksScore(WilksScore score) async {
    await _databaseService.createWilksScore(score);
  }

  Future<List<WilksScore>> getScoresForProfile(int profileId) async {
    return await _databaseService.getScoresForProfile(profileId);
  }

  Future<void> deleteWilksScore(int id) async {
    await _databaseService.deleteWilksScore(id);
  }
}
