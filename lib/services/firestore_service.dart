import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_quiz/models/question.dart';
import 'package:tic_quiz/services/storage_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  Stream<List<Map<String, dynamic>>> getQuestionsStream(String quizId) {
    return _db
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList(),
        );
  }

  Future<void> deleteQuestion(
    String quizId,
    String questionId,
    String? imageUrl,
  ) async {
    try {
      if (imageUrl != null) {
        await _storageService.deleteImage(imageUrl);
      }
      await _db
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .doc(questionId)
          .delete();
    } catch (e) {
      print('Delete error: $e');
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      final data = doc.data();
      print(
        'Checking isAdmin for UID: $uid, Document exists: ${doc.exists}, Data: $data',
      );
      return doc.exists && (data?['isAdmin'] ?? false);
    } catch (e) {
      print('Firestore error for UID $uid: $e');
      return false;
    }
  }

  Future<void> updateQuestion(
    String quizId,
    String questionId,
    Question question,
  ) async {
    try {
      String? newImageUrl = question.imageUrl;
      if (question.imageUrl == null && question.id.isNotEmpty) {
        final doc =
            await _db
                .collection('quizzes')
                .doc(quizId)
                .collection('questions')
                .doc(questionId)
                .get();
        newImageUrl = doc.data()?['imageUrl'];
      }
      await _db
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .doc(questionId)
          .set({
            'text': question.text,
            'options': question.options,
            'correctIndex': question.correctIndex,
            'imageUrl': newImageUrl,
          }, SetOptions(merge: true));
    } catch (e) {
      print('Update error: $e');
    }
  }

  Future<void> addQuestion(String quizId, Question question) async {
    try {
      final docRef = await _db
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .add({
            'text': question.text,
            'options': question.options,
            'correctIndex': question.correctIndex,
            'imageUrl': question.imageUrl,
          });
      await docRef.update({'id': docRef.id});
    } catch (e) {
      print('Add error: $e');
    }
  }
}
