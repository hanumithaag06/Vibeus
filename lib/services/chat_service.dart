import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final db = FirebaseFirestore.instance;

  static Future<void> sendMessage(
    String roomId, String message, String username) async {
    await db
      .collection('rooms')
      .doc(roomId)
      .collection('messages')
      .add({
        'text': message,
        'user': username,
        'time': FieldValue.serverTimestamp(),
      });
  }

  static Stream<QuerySnapshot> getMessages(String roomId) {
    return db
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}