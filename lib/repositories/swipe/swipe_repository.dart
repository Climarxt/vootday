import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SwipeRepository {
  final FirebaseFirestore _firebaseFirestore;

  SwipeRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post>> getSwipeOOTD() async {
    debugPrint(
        'getSwipeOOTD : Début de la récupération des posts OOTD de la base de données Firestore');
    try {
      var snapshot = await _firebaseFirestore.collection('posts').get();
      List<Post> posts = [];
      debugPrint('getSwipeOOTD : Nombre de documents récupérés: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        var post = await Post.fromDocument(doc);
        if (post != null) {
          posts.add(post);
          debugPrint(
              'getSwipeOOTD : Post ajouté: ${post.toString()}'); // Affiche des détails sur le post
        }
      }
      debugPrint('getSwipeOOTD : Nombre total de posts OOTD récupérés: ${posts.length}');
      return posts;
    } catch (e) {
      debugPrint('getSwipeOOTD : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      throw Exception('getSwipeOOTD : Erreur lors du chargement des posts: ${e.toString()}');
    }
  }
}
