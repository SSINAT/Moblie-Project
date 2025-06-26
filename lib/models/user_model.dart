class UserModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String grade;
  final String language;
  final String? photoUrl;
//set data to model 
  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.grade,
    required this.language,
    this.photoUrl,
  });
UserModel copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? bio,
    String? grade,
    String? language,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      grade: grade ?? this.grade,
      language: language ?? this.language,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
//Create new questions from JSON or Firebase 
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      grade: map['grade'] ?? '',
      language: map['language'] ?? '',
     photoUrl: map['photoUrl'] ?? ''
    );
  }
//Convert the object back to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'grade': grade,
      'language': language,
      'photoUrl': photoUrl,
    };
  }
}
