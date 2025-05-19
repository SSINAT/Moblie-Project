import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_ranking.dart';

class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<UserRanking>> getTopRankings() async {
    try {
      // Get top 50 users by points
      final snapshot = await _firestore
          .collection('users')
          .orderBy('points', descending: true)
          .limit(50)
          .get();

      if (snapshot.docs.isEmpty) {
        await _seedRankingData();
        return _getSeededRankings();
      }

      // Map to UserRanking objects with rank
      List<UserRanking> rankings = [];
      int rank = 1;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['uid'] = doc.id;
        rankings.add(UserRanking.fromMap(data, rank));
        rank++;
      }

      return rankings;
    } catch (e) {
      print('Error getting rankings: $e');
      return [];
    }
  }

  Future<UserRanking?> getCurrentUserRanking() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      // Get current user data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) return null;
      
      final userData = userDoc.data()!;
      userData['uid'] = userId;
      
      // Get user's rank by counting users with more points
      final userPoints = userData['points'] ?? 0;
      
      final higherRankedUsers = await _firestore
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

  Future<void> _seedRankingData() async {
    // Sample user data for demonstration
    final users = [
      {
        'uid': 'user1',
        'name': 'Ke',
        'photoUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
        'points': 8500,
      },
      {
        'uid': 'user2',
        'name': 'Elon',
        'photoUrl': 'https://randomuser.me/api/portraits/men/22.jpg',
        'points': 7200,
      },
      {
        'uid': 'user3',
        'name': 'Jonh',
        'photoUrl': 'https://randomuser.me/api/portraits/men/91.jpg',
        'points': 6800,
      },
      {
        'uid': 'user4',
        'name': 'Nico',
        'photoUrl': 'https://randomuser.me/api/portraits/men/42.jpg',
        'points': 3800,
      },
      {
        'uid': 'user5',
        'name': 'Papilo',
        'photoUrl': 'https://randomuser.me/api/portraits/men/52.jpg',
        'points': 6900,
      },
      {
        'uid': 'user6',
        'name': 'Tony',
        'photoUrl': 'https://randomuser.me/api/portraits/women/32.jpg',
        'points': 2300,
      },
      {
        'uid': 'user7',
        'name': 'Darong',
        'photoUrl': 'https://randomuser.me/api/portraits/men/62.jpg',
        'points': 1800,
      },
      {
        'uid': 'user8',
        'name': 'Thavarith',
        'photoUrl': 'https://randomuser.me/api/portraits/men/72.jpg',
        'points': 1600,
      },
    ];

    // Add current user if authenticated
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'name': currentUser.displayName ?? 'You',
        'photoUrl': currentUser.photoURL ?? '',
        'points': 1,
      }, SetOptions(merge: true));
    }

    // Add sample users
    final batch = _firestore.batch();
    for (var user in users) {
      final docRef = _firestore.collection('users').doc(user['uid'] as String);
      batch.set(docRef, {
        'name': user['name'],
        'photoUrl': user['photoUrl'],
        'points': user['points'],
      });
    }

    await batch.commit();
  }

  Future<List<UserRanking>> _getSeededRankings() async {
    final users = [
      UserRanking(
        uid: 'user1',
        name: 'Ke',
        photoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        points: 8500,
        rank: 1,
      ),
      UserRanking(
        uid: 'user2',
        name: 'Elon',
        photoUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
        points: 7200,
        rank: 2,
      ),
      UserRanking(
        uid: 'user3',
        name: 'Jonh',
        photoUrl: 'https://randomuser.me/api/portraits/men/91.jpg',
        points: 6800,
        rank: 3,
      ),
      UserRanking(
        uid: 'user5',
        name: 'Papilo',
        photoUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
        points: 6900,
        rank: 4,
      ),
      UserRanking(
        uid: 'user4',
        name: 'Nico',
        photoUrl: 'https://randomuser.me/api/portraits/men/42.jpg',
        points: 3800,
        rank: 5,
      ),
      UserRanking(
        uid: 'user6',
        name: 'Tony',
        photoUrl: 'https://randomuser.me/api/portraits/women/32.jpg',
        points: 2300,
        rank: 6,
      ),
      UserRanking(
        uid: 'user7',
        name: 'Darong',
        photoUrl: 'https://randomuser.me/api/portraits/men/62.jpg',
        points: 1800,
        rank: 7,
      ),
      UserRanking(
        uid: 'user8',
        name: 'Thavarith',
        photoUrl: 'https://randomuser.me/api/portraits/men/72.jpg',
        points: 1600,
        rank: 8,
      ),
    ];

    return users;
  }

  // Update user points after completing a quiz
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