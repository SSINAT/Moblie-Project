import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_ranking.dart';

class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<UserRanking>> getTopRankings() {
    return _firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          List<UserRanking> rankings = [];
          int rank = 1;
          for (var doc in snapshot.docs) {
            final data = doc.data();
            data['uid'] = doc.id;
            rankings.add(UserRanking.fromMap(data, rank));
            rank++;
          }
          return rankings;
        })
        .handleError((e) {
          print('Error getting rankings: $e');
          return [];
        });
  }

  Future<UserRanking?> getCurrentUserRanking() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data()!;
      userData['uid'] = userId;
      final userPoints = userData['points'] ?? 0;

      final higherRankedUsers =
          await _firestore
              .collection('users')
              .where('points', isGreaterThan: userPoints)
              .count()
              .get();

      final rank = higherRankedUsers.count! + 1;

      return UserRanking.fromMap(userData, rank);
    } catch (e) {
      print('Error getting current user ranking: $e');
      return null;
    }
  }

  Future<void> updateUserPoints(int pointsToAdd) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'points': FieldValue.increment(pointsToAdd),
      });
    } catch (e) {
      print('Error updating user points: $e');
    }
  }
}
