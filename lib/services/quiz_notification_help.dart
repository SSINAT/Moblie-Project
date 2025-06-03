import 'notification_service.dart';

class QuizNotificationHelper {
  static final NotificationService _notificationService = NotificationService();

  // Send achievement notification
  static Future<void> sendAchievementNotification({
    required String userId,
    required String achievementTitle,
    required int position,
  }) async {
    await _notificationService.sendNotificationToUser(
      userId: userId,
      title: achievementTitle,
      message: 'up to top $position',
      type: 'achievement',
      data: {'position': position, 'achievementType': 'ranking'},
    );
  }

  // Send quiz completion notification
  static Future<void> sendQuizCompletionNotification({
    required String userId,
    required String quizTitle,
    required int score,
  }) async {
    await _notificationService.sendNotificationToUser(
      userId: userId,
      title: 'Quiz Completed',
      message: 'You scored $score points in $quizTitle',
      type: 'quiz',
      data: {'quizTitle': quizTitle, 'score': score},
    );
  }

  // Send ranking update notification
  static Future<void> sendRankingUpdateNotification({
    required String userId,
    required String userName,
    required int newRank,
  }) async {
    await _notificationService.sendNotificationToUser(
      userId: userId,
      title: '$userName Top $newRank',
      message: 'Congratulations! You\'ve reached position $newRank',
      type: 'ranking',
      data: {'rank': newRank, 'userName': userName},
    );
  }

  // Send general notification
  static Future<void> sendGeneralNotification({
    required String userId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await _notificationService.sendNotificationToUser(
      userId: userId,
      title: title,
      message: message,
      type: 'general',
      data: data,
    );
  }
}
