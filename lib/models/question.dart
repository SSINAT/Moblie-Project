class Question {
  String id;
  String text;
  List<String> options;
  int correctIndex;
  String? imageUrl;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
  });
//Create new questions from JSON or Firebase 
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctIndex: data['correctIndex'] ?? 0,
      imageUrl: data['imageUrl'],
    );
  }
//Convert the object back to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctIndex': correctIndex,
      'imageUrl': imageUrl,
    };
  }
}
