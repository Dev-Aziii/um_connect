class UserModel {
  final String uid;
  final String email;
  final String role; // e.g., 'Student', 'CSG', 'Faculty'
  final String college; // e.g., 'College of Computing Education'

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.college,
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'Student', // Default to 'Student' if no role is set
      college: data['college'] ?? 'N/A',
    );
  }
}
