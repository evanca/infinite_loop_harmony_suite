import '../leaderboard_entry.dart';

abstract class LeaderboardPersistence {
  Future<List<LeaderboardEntry>> getLeaderboard();

  Future<void> saveLeaderboardEntry(LeaderboardEntry entry);
}
