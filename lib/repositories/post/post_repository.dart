// ignore_for_file: avoid_debugPrint

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/collection_model.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/base_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> deletePost({required String postId}) async {
    WriteBatch batch = _firebaseFirestore.batch();
    debugPrint('deletePost : Début de la suppression du post avec ID: $postId');

    // Suppression du post dans la collection 'posts'
    DocumentReference postRef =
        _firebaseFirestore.collection(Paths.posts).doc(postId);
    debugPrint('deletePost : Suppression du post dans la collection posts');
    batch.delete(postRef);

    // Suppression des références du post dans les sous-collections
    await _deletePostReferencesInSubCollections(batch, postRef, 'participants');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_event');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_month');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_ootd');

    // Exécution du batch pour effectuer toutes les suppressions
    debugPrint(
        'deletePost : Exécution du batch pour la suppression du post et des références associées');
    await batch.commit();
    debugPrint(
        'deletePost : Suppression terminée pour le post avec ID: $postId');
  }

  Future<void> _deletePostReferencesInSubCollections(
      WriteBatch batch, DocumentReference postRef, String subCollection) async {
    debugPrint(
        '_deletePostReferencesInSubCollections : Recherche du post dans les sous-collections $subCollection');
    QuerySnapshot snapshot = await _firebaseFirestore
        .collectionGroup(subCollection)
        .where('post_ref', isEqualTo: postRef)
        .get();

    if (snapshot.docs.isEmpty) {
      debugPrint(
          '_deletePostReferencesInSubCollections : Aucune référence trouvée dans $subCollection pour le post_ref: $postRef');
    } else {
      debugPrint(
          '_deletePostReferencesInSubCollections : Nombre de références trouvées dans $subCollection: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        debugPrint(
            '_deletePostReferencesInSubCollections : Suppression de la référence: ${doc.id} dans $subCollection dans le batch');
        batch.delete(doc.reference);
      }
    }
  }

  Future<void> deleteCollection({required String collectionId}) async {
    WriteBatch batch = _firebaseFirestore.batch();
    debugPrint(
        'deleteCollection : Début de la suppression de la collection avec ID: $collectionId');

    DocumentReference collectionRef =
        _firebaseFirestore.collection(Paths.collections).doc(collectionId);
    debugPrint(
        'deleteCollection : Suppression de la collection dans la collection collections');
    batch.delete(collectionRef);

    // Suppression des références du post dans les sous-collections
    await _deleteCollectionReferencesInSubCollections(
        batch, collectionRef, 'mycollection');

    // Exécution du batch pour effectuer toutes les suppressions
    debugPrint(
        'deleteCollection : Exécution du batch pour la suppression de la collection et des références associées');
    await batch.commit();
    debugPrint(
        'deleteCollection : Suppression terminée pour la collection avec ID: $collectionId');
  }

  Future<void> _deleteCollectionReferencesInSubCollections(WriteBatch batch,
      DocumentReference collectionRef, String subCollection) async {
    debugPrint(
        '_deleteCollectionReferencesInSubCollections : Recherche de la collection dans les sous-collections $subCollection');
    QuerySnapshot snapshot = await _firebaseFirestore
        .collectionGroup(subCollection)
        .where('collection_ref', isEqualTo: collectionRef)
        .get();

    if (snapshot.docs.isEmpty) {
      debugPrint(
          '_deleteCollectionReferencesInSubCollections : Aucune référence trouvée dans $subCollection pour le post_ref: $collectionRef');
    } else {
      debugPrint(
          '_deleteCollectionReferencesInSubCollections : Nombre de références trouvées dans $subCollection: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        debugPrint(
            '_deleteCollectionReferencesInSubCollections : Suppression de la référence: ${doc.id} dans $subCollection dans le batch');
        batch.delete(doc.reference);
      }
    }
  }

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    debugPrint('Début de la méthode createComment');

    debugPrint('Ajout du commentaire dans Firestore');
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument())
        .then((_) => debugPrint('Commentaire ajouté avec succès'))
        .catchError(
            (e) => debugPrint('Erreur lors de l\'ajout du commentaire: $e'));

    debugPrint('Création de la notification');
    final notification = Notif(
      type: NotifType.comment,
      fromUser: comment.author,
      post: post,
      date: DateTime.now(),
    );

    debugPrint('Ajout de la notification dans Firestore');
    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument())
        .then((_) => debugPrint('Notification ajoutée avec succès'))
        .catchError((e) =>
            debugPrint('Erreur lors de l\'ajout de la notification: $e'));

    debugPrint('Fin de la méthode createComment');
  }

  @override
  void createLike({
    required Post post,
    required String userId,
  }) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.like,
      fromUser: User.empty.copyWith(id: userId),
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post?> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post!.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

  Future<Post?> getPostById(String postId) async {
    try {
      DocumentSnapshot postSnap =
          await _firebaseFirestore.collection(Paths.posts).doc(postId).get();

      if (postSnap.exists) {
        return Post.fromDocument(postSnap);
      } else {
        // Handle the case where the post does not exist.
        debugPrint("Le post n'existe pas.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch.
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> createPostEvent(
      {required Post post, required String eventId}) async {
    // Créer une référence de document pour le nouveau post.
    DocumentReference postRef =
        _firebaseFirestore.collection(Paths.posts).doc();

    // Préparer le document pour le post avec une référence aléatoire.
    final postDocument = post.copyWith(id: postRef.id).toDocument();

    // Créer un document pour le participant dans la sous-collection de l'eventId avec une référence au post.
    final participantDocument = {'post_ref': postRef, 'userId': post.author.id};

    // Écrire les deux documents en utilisant une transaction pour garantir que les deux opérations réussissent ou échouent ensemble.
    await _firebaseFirestore.runTransaction((transaction) async {
      // Ajouter le nouveau post à la collection des posts.
      transaction.set(postRef, postDocument);

      // Ajouter la référence du post au document du participant dans la sous-collection des participants.
      DocumentReference participantRef = _firebaseFirestore
          .collection(Paths.events)
          .doc(eventId)
          .collection('participants')
          .doc();
      transaction.set(participantRef, participantDocument);
    });
  }

  Future<List<Collection?>> getMyCollection({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getMyCollection : Attempting to fetch collection references from Firestore...');

      // Récupérer les références de la collection de l'utilisateur
      QuerySnapshot userCollectionSnap = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('mycollection')
          .orderBy('date', descending: true)
          .get();

      // Extraire les références de collection
      List<DocumentReference> collectionRefs = userCollectionSnap.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data != null && data.containsKey('collection_ref')
                ? data['collection_ref'] as DocumentReference?
                : null;
          })
          .where((ref) => ref != null)
          .cast<DocumentReference>()
          .toList();

      debugPrint(
          'getMyCollection : Collection references fetched. Fetching each collection document...');

      List<Future<Collection?>> futureCollections = collectionRefs.map(
        (ref) async {
          DocumentSnapshot collectionDoc = await ref.get();
          return Collection.fromDocument(collectionDoc);
        },
      ).toList();

      // Utiliser Future.wait pour résoudre toutes les collections
      List<Collection?> collections = await Future.wait(futureCollections);

      debugPrint(
          'getMyCollection : Collection objects created. Total collections: ${collections.length}');

      if (collections.isNotEmpty) {
        debugPrint(
            'getMyCollection : First collection details: ${collections.first}');
      }

      return collections;
    } catch (e) {
      debugPrint(
          'getMyCollection : An error occurred while fetching collections: ${e.toString()}');
      return [];
    }
  }

  Future<List<Collection?>> getYourCollection({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getYourCollection : Attempting to fetch public collection references from Firestore...');

      // Récupérer les références de la collection de l'utilisateur
      QuerySnapshot userCollectionSnap = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('mycollection')
          .orderBy('date', descending: true)
          .get();

      List<DocumentReference> collectionRefs = userCollectionSnap.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data != null && data.containsKey('collection_ref')
                ? data['collection_ref'] as DocumentReference?
                : null;
          })
          .where((ref) => ref != null)
          .cast<DocumentReference>()
          .toList();

      debugPrint(
          'getYourCollection : Collection references fetched. Fetching each collection document...');

      List<Future<Collection?>> futureCollections = collectionRefs.map(
        (ref) async {
          DocumentSnapshot collectionDoc = await ref.get();
          Collection? collection = await Collection.fromDocument(
              collectionDoc); // Ajout de 'await' ici
          if (collection != null && collection.public) {
            return collection; // Filtrer pour garder seulement les collections publiques
          }
          return null;
        },
      ).toList();

      List<Collection?> collections = await Future.wait(futureCollections);
      collections.removeWhere((collection) => collection == null);

      debugPrint(
          'getYourCollection : Public collection objects created. Total collections: ${collections.length}');

      if (collections.isNotEmpty) {
        debugPrint(
            'getYourCollection : First public collection details: ${collections.first}');
      }

      return collections;
    } catch (e) {
      debugPrint(
          'getYourCollection : An error occurred while fetching public collections: ${e.toString()}');
      return [];
    }
  }

  Future<void> updateCollectionPublicStatus(
      {required String collectionId, required bool newStatus}) async {
    DocumentReference collectionRef =
        _firebaseFirestore.collection(Paths.collections).doc(collectionId);
    await collectionRef.update({'public': newStatus});
  }

  Future<bool> isPostInCollection(
      {required String postId, required String collectionId}) async {
    try {
      debugPrint(
          'isPostInCollection : Attempting to check post in collection from Firestore...');

      DocumentReference postRef =
          _firebaseFirestore.collection(Paths.posts).doc(postId);

      // Requête pour trouver le post dans la sous-collection spécifique de la collection
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.collections)
          .doc(collectionId)
          .collection(
              'feed_collection') // Assurez-vous que c'est le bon nom de sous-collection
          .where('post_ref', isEqualTo: postRef)
          .get();

      // Vérifier si le post existe dans la sous-collection
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint(
          'isPostInCollection : Erreur lors de la vérification du post dans la collection: ${e.toString()}');
      return false; // Retourne false en cas d'erreur
    }
  }

  Future<void> deletePostRefFromCollection(
      {required String postId, required String collectionId}) async {
    try {
      debugPrint(
          'deletePostRefFromCollection : Suppression du post_ref de la collection...');

      DocumentReference postRef =
          _firebaseFirestore.collection(Paths.posts).doc(postId);

      // Recherchez la référence spécifique du post dans la sous-collection 'feed_collection' de la collection spécifiée
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(Paths.collections)
          .doc(collectionId)
          .collection('feed_collection') // Nom de la sous-collection
          .where('post_ref', isEqualTo: postRef)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Supprimez uniquement la première référence trouvée, car elle doit être unique
        await snapshot.docs.first.reference.delete();
        debugPrint(
            'deletePostRefFromCollection : Post_ref supprimé de la collection avec succès.');
      } else {
        debugPrint(
            'deletePostRefFromCollection : Aucun post_ref trouvé dans la collection.');
      }
    } catch (e) {
      debugPrint(
          'deletePostRefFromCollection : Erreur lors de la suppression du post_ref de la collection: ${e.toString()}');
      throw Exception(
          'Erreur lors de la suppression du post_ref de la collection');
    }
  }

  Future<bool> isPostInLikes(
      {required String postId, required String userId}) async {
    try {
      debugPrint(
          'isPostInLikes : Checking if post $postId is in likes for user $userId...');

      DocumentReference postRef =
          _firebaseFirestore.collection(Paths.posts).doc(postId);

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      bool result = querySnapshot.docs.isNotEmpty;
      debugPrint('isPostInLikes : Post $postId is in likes - $result');

      return result;
    } catch (e) {
      debugPrint(
          'isPostInLikes : Error checking post $postId in likes for user $userId: ${e.toString()}');
      return false; // Retourne false en cas d'erreur
    }
  }

  Future<void> deletePostRefFromLikes(
      {required String postId, required String userId}) async {
    try {
      debugPrint(
          'deletePostRefFromLikes : Suppression du post_ref des likes...');

      DocumentReference postRef =
          _firebaseFirestore.collection(Paths.posts).doc(postId);

      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        debugPrint(
            'deletePostRefFromLikes : Post_ref supprimé des likes avec succès.');
      } else {
        debugPrint(
            'deletePostRefFromLikes : Aucun post_ref trouvé dans la collection.');
      }
    } catch (e) {
      debugPrint(
          'deletePostRefFromLikes : Erreur lors de la suppression du post_ref des likes: ${e.toString()}');
      throw Exception('Erreur lors de la suppression du post_ref des likes');
    }
  }
}
