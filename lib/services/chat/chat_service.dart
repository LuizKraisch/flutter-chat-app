import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final usersSnapshot = await _firestore.collection('users').get();

      return usersSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != _auth.currentUser!.email &&
              !blockedUsersIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('reports').add(report);
  }

  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  Future<void> unblockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .doc(userId)
        .delete();
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('blocked_users')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUsersIds
          .map((id) => _firestore.collection('users').doc(id).get()));

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
