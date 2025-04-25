import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/models/password.dart';

class FirestoreService {
  final CollectionReference _passwordsCollection =
      FirebaseFirestore.instance.collection('passwords');

  Future<String> _generateCustomId() async {
    final snapshot = await _passwordsCollection.get();
    final count = snapshot.docs.length + 1;
    return 'PASSWD${count.toString().padLeft(4, '0')}';
  }

  Future<void> addPassword(PasswordModel password) async {
    final customId = await _generateCustomId();
    await _passwordsCollection.doc(customId).set({
      ...password.toJson(),
      'id': customId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updatePassword(PasswordModel password) async {
    await _passwordsCollection.doc(password.id).update({
      ...password.toJson(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deletePassword(String id) async {
    await _passwordsCollection.doc(id).delete();
  }

  Stream<List<PasswordModel>> getPasswords() {
    return _passwordsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PasswordModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}