import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listen to users collection
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('userdata').snapshots();
  }

  // ---------- CRUD for `userdata` collection ----------

  // Real time updates, AI created this one but probably not neccessary
  // can just onetime on page load / page switch
  Stream<QuerySnapshot> getUserdataStream() {
    return _firestore.collection('userdata').snapshots();
  }

  // Get (once) - single read
  Future<List<Map<String, dynamic>>> getUserdataOnce() async {
    final snapshot = await _firestore.collection('userdata').get();
    return snapshot.docs.map((d) {
      final data = <String, dynamic>{'id': d.id};
      final map = d.data();
      data.addAll(map);
      return data;
    }).toList();
  }

  // Create user
  Future<DocumentReference> createUserdata(Map<String, dynamic> data) async {
    // Check if username already exists
    if (data.containsKey('username')) {
      final existingUser = await _firestore
          .collection('userdata')
          .where('username', isEqualTo: data['username'])
          .limit(1)
          .get();
      
      if (existingUser.docs.isNotEmpty) {
        throw Exception('Username already exists');
      }
    }
    
    return await _firestore.collection('userdata').add(data);
  }

  // Update data, based on ID
  Future<void> updateUserdata(String id, Map<String, dynamic> data) async {
    // Check if username already exists (excluding current user)
    if (data.containsKey('username')) {
      final existingUser = await _firestore
          .collection('userdata')
          .where('username', isEqualTo: data['username'])
          .limit(1)
          .get();
      
      if (existingUser.docs.isNotEmpty && existingUser.docs.first.id != id) {
        throw Exception('Username already exists');
      }
    }
    
    await _firestore.collection('userdata').doc(id).update(data);
  }

  // Get info by ID
  Future<Map<String, dynamic>?> getUserdataById(String id) async {
    final doc = await _firestore.collection('userdata').doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data();
    final result = <String, dynamic>{'id': doc.id};
    if (data is Map<String, dynamic>) {
      result.addAll(data);
    }
    return result;
  }

  // Login Function
  // username and password are matched against firebase params
  // not encrypted
  Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    final query = await _firestore
        .collection('userdata')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    final data = doc.data();
    final result = <String, dynamic>{'id': doc.id};
    result.addAll(data);

    return result;
  }//NOTE: Store ID after login in app for easier refetch

}