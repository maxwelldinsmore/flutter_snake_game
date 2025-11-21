import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a user to the database
  Future<void> addUser(String name, int age) async {
    await _firestore.collection('users').add({
      'name': name,
      'age': age,
    });
  }

  // Listen to users collection
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  // Example method to print all users
  void listenToUsers() {
    getUsersStream().listen((snapshot) {
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    });
  }
}