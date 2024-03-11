import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endless_runner/leaderboard/persistence/leaderboard_persistence.dart';

import '../leaderboard_entry.dart';

class CloudLeaderboardPersistence extends LeaderboardPersistence {
  static const String _leaderboardCollection = 'leaderboard';

  final db = FirebaseFirestore.instance;

  @override
  Future<List<LeaderboardEntry>> getLeaderboard() {
    return db
        .collection(_leaderboardCollection)
        .orderBy('overallScore', descending: true)
        .limit(42)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map((doc) => LeaderboardEntry.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> saveLeaderboardEntry(LeaderboardEntry entry) async {
    final existingEntry = await db
        .collection(_leaderboardCollection)
        .doc(entry.userId)
        .get()
        .then((doc) => doc.data());

    if (existingEntry != null) {
      // Maybe update existing user score
      final LeaderboardEntry existing =
          LeaderboardEntry.fromJson(existingEntry);

      if (entry.overallScore > existing.overallScore) {
        await db
            .collection(_leaderboardCollection)
            .doc(entry.userId)
            .set(entry.toJson());
      }
    } else {
      // Create new entry
      await db
          .collection(_leaderboardCollection)
          .doc(entry.userId)
          .set(entry.toJson());
    }
  }
}
