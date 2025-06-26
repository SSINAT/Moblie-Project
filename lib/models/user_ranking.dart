class UserRanking {
  final String uid;
  final String name;
  final String photoUrl;
  final int stars; 
  final int rank;

  UserRanking({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.stars,
    required this.rank,
  });

  factory UserRanking.fromMap(Map<String, dynamic> data, int rank) {
    return UserRanking(
      uid: data['uid'] ?? '',
      name: data['name'] ?? 'Unknown',
      photoUrl: data['photoUrl'] ?? '',
      stars: data['stars'] ?? 0, 
      rank: rank,
    );
  }
}
