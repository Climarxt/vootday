import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SwipeRepository {
  final FirebaseFirestore _firebaseFirestore;

  SwipeRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post>> getSwipeWoman({
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getSwipeWoman : Début de la récupération des posts pour femmes de la base de données Firestore');
    try {
      QuerySnapshot postsSnap;
      if (lastPostId == null) {
        postsSnap = await _firebaseFirestore
            .collection(Paths.posts)
            .where('selectedGender', isEqualTo: 'Féminin')
            .orderBy('likes', descending: true)
            .limit(50)
            .get();
      } else {
        final lastPostDoc = await _firebaseFirestore
            .collection(Paths.posts)
            .doc(lastPostId)
            .get();

        if (!lastPostDoc.exists) {
          debugPrint(
              'getSwipeWoman : Aucun document postérieur trouvé, retourne une liste vide');
          return [];
        }

        postsSnap = await _firebaseFirestore
            .collection(Paths.posts)
            .where('selectedGender', isEqualTo: 'Féminin')
            .orderBy('likes', descending: true)
            .startAfterDocument(lastPostDoc)
            .limit(50)
            .get();
      }

      List<Post> posts = [];
      for (var doc in postsSnap.docs) {
        var post = await Post.fromDocument(doc);
        if (post != null) {
          posts.add(post);
          debugPrint('getSwipeWoman : Post ajouté: ${post.toString()}');
        }
      }
      debugPrint(
          'getSwipeWoman : Nombre total de posts pour femmes récupérés: ${posts.length}');
      return posts;
    } catch (e) {
      debugPrint(
          'getSwipeWoman : Erreur lors du chargement des posts pour femmes: ${e.toString()}');
      throw Exception(
          'getSwipeWoman : Erreur lors du chargement des posts: ${e.toString()}');
    }
  }

  Future<List<Post>> getSwipeMan({
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getSwipeMan : Début de la récupération des posts pour hommes de la base de données Firestore');
    try {
      QuerySnapshot postsSnap;
      if (lastPostId == null) {
        postsSnap = await _firebaseFirestore
            .collection(Paths.posts)
            .where('selectedGender', isEqualTo: 'Masculin')
            .orderBy('likes', descending: true)
            .limit(50)
            .get();
      } else {
        final lastPostDoc = await _firebaseFirestore
            .collection(Paths.posts)
            .doc(lastPostId)
            .get();

        if (!lastPostDoc.exists) {
          debugPrint(
              'getSwipeMan : Aucun document postérieur trouvé, retourne une liste vide');
          return [];
        }

        postsSnap = await _firebaseFirestore
            .collection(Paths.posts)
            .where('selectedGender', isEqualTo: 'Masculin')
            .orderBy('likes', descending: true)
            .startAfterDocument(lastPostDoc)
            .limit(50)
            .get();
      }

      List<Post> posts = [];
      for (var doc in postsSnap.docs) {
        var post = await Post.fromDocument(doc);
        if (post != null) {
          posts.add(post);
          debugPrint('getSwipeMan : Post ajouté: ${post.toString()}');
        }
      }
      debugPrint(
          'getSwipeMan : Nombre total de posts pour hommes récupérés: ${posts.length}');
      return posts;
    } catch (e) {
      debugPrint(
          'getSwipeMan : Erreur lors du chargement des posts pour hommes: ${e.toString()}');
      throw Exception(
          'getSwipeMan : Erreur lors du chargement des posts: ${e.toString()}');
    }
  }
}