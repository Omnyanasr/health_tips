class UserModel {
  String uid;
  int age;
  String fitnessGoal;
  String? fcmToken;

  UserModel({
    required this.uid,
    required this.age,
    required this.fitnessGoal,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'age': age,
      'fitnessGoal': fitnessGoal,
      'fcmToken': fcmToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      age: map['age'],
      fitnessGoal: map['fitnessGoal'],
      fcmToken: map['fcmToken'],
    );
  }
}
