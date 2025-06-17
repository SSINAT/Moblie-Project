class UserRanking {
  final String uid;
  final String name;
  final String photoUrl;
  final int points;
  final int rank;

  UserRanking({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.points,
    required this.rank,
  });

  factory UserRanking.fromMap(Map<String, dynamic> map, int rank) {
    return UserRanking(
      uid: map['uid'] ?? '',
      name: map['name'] ?? 'Anonymous',
      photoUrl: map['photoUrl'] ?? '',
      points: map['points'] ?? 0,
      rank: rank,
    );
  }
}
