import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class EventFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Post Event comment
  Future<void> postComment(String eventId, String text, String uid,
      String username, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        await _firestore
            .collection('events')
            .doc(eventId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
