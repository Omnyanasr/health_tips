import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../utils/user_model.dart';

class RegistrationController {
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationService _notificationService = NotificationService();

  Future<String> registerUser(int age, String fitnessGoal, String uid) async {
    final token = await _notificationService.getFcmToken();

    UserModel user = UserModel(
      uid: uid,
      age: age,
      fitnessGoal: fitnessGoal,
      fcmToken: token,
    );

    await _firestoreService.saveUser(user);

    String tip = _getTipForUser(age, fitnessGoal);
    await _notificationService.showNotification('Daily Health Tip', tip);

    return 'User Registered and Tip Sent!';
  }

  String _getTipForUser(int age, String goal) {
    if (age < 18) {
      return 'Remember to get plenty of sleep and stay hydrated!';
    } else if (age >= 18 && age <= 40) {
      switch (goal) {
        case 'Weight Loss':
          return 'Drink a glass of water before meals to help weight loss.';
        case 'Muscle Gain':
          return 'Add extra protein to your breakfast today.';
        default:
          return 'Take a 10-minute walk to refresh yourself.';
      }
    } else {
      // age > 40
      switch (goal) {
        case 'Weight Loss':
          return 'Focus on balanced meals and light exercises for weight loss.';
        case 'Muscle Gain':
          return 'Incorporate strength training with proper warm-ups.';
        default:
          return 'Try gentle stretching exercises to maintain flexibility.';
      }
    }
  }
}
