class UserModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String grade;
  final String language;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.grade,
    required this.language,
    this.profileImageUrl,
  });
UserModel copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? bio,
    String? grade,
    String? language,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      grade: grade ?? this.grade,
      language: language ?? this.language,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      grade: map['grade'] ?? '',
      language: map['language'] ?? '',
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'grade': grade,
      'language': language,
      'profileImageUrl': profileImageUrl,
    };
  }
}
