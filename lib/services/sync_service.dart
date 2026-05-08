import 'package:cloud_firestore/cloud_firestore.dart';

class SyncService {
  static final db = FirebaseFirestore.instance;

  static Future<void> playSong(String roomId, String videoId) async {
    await db.collection('rooms').doc(roomId).set({
      'videoId': videoId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Stream<String?> listenSong(String roomId) {
    return db
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((doc) => doc.data()?['videoId']);
  }
}