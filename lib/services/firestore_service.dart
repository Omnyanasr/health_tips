import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _db.collection('Users').doc(user.uid).set(user.toMap());
  }
}
