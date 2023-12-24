import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SwipeRepository {
  final FirebaseFirestore _firebaseFirestore;

  SwipeRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post>> getSwipeOOTD() async {
    try {
      var snapshot = await _firebaseFirestore.collection('posts').get();
      List<Post> posts = [];
      for (var doc in snapshot.docs) {
        var post = await Post.fromDocument(doc);
        if (post != null) {
          posts.add(post);
        }
      }
      return posts;
    } catch (e) {
      throw Exception('Erreur lors du chargement des posts: ${e.toString()}');
    }
  }
}
