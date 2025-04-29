import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/models/user.dart';

class FirestoreService {
  final CollectionReference _passwordsCollection = FirebaseFirestore.instance.collection('passwords');
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<String> _generateCustomPasswordId() async {
    final snapshot = await _passwordsCollection.get();
    final count = snapshot.docs.length + 1;
    return 'PASSWD${count.toString().padLeft(4, '0')}';
  }

  Future<String> _generateCustomUserId() async {
    final snapshot = await _usersCollection.get();
    final count = snapshot.docs.length + 1;
    return 'USERID${count.toString().padLeft(5, '0')}';
  }

  Future<void> addPassword(PasswordModel password) async {
    final customId = await _generateCustomPasswordId();
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return _passwordsCollection
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PasswordModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> registerUser(String name, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final customId = await _generateCustomUserId();
      final userModel = UserModel(
        id: customId,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _usersCollection.doc(userCredential.user!.uid).set(userModel.toJson());
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Registration failed: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        textColor: Colors.white,
      );
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }
}