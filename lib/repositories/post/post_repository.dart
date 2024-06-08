// ignore_for_file: avoid_debugPrint

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/base_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('PostRepository');

  Future<void> deleteCollection({required String collectionId}) async {
    WriteBatch batch = _firebaseFirestore.batch();
    debugPrint(
        'deleteCollection : Début de la suppression de la collection avec ID: $collectionId');

    DocumentReference collectionRef =
        _firebaseFirestore.collection(Paths.collections).doc(collectionId);

    // Suppression des documents dans la sous-collection 'mycollection'
    await _deleteDocumentsInSubCollections(
        batch, collectionRef, 'mycollection');

    // Suppression des documents dans la sous-collection directe 'feed_collection'
    await _deleteDirectSubCollectionDocuments(
        batch, collectionRef, 'feed_collection');

    debugPrint(
        'deleteCollection : Suppression de la collection dans la collection collections');
    batch.delete(collectionRef);

    // Exécution du batch pour effectuer toutes les suppressions
    debugPrint(
        'deleteCollection : Exécution du batch pour la suppression de la collection et des références associées');
    await batch.commit();
    debugPrint(
        'deleteCollection : Suppression terminée pour la collection avec ID: $collectionId');
  }

  Future<void> _deleteDirectSubCollectionDocuments(WriteBatch batch,
      DocumentReference parentDocRef, String subCollectionName) async {
    debugPrint(
        '_deleteDirectSubCollectionDocuments : Recherche de documents dans la sous-collection $subCollectionName');
    QuerySnapshot snapshot =
        await parentDocRef.collection(subCollectionName).get();

    if (snapshot.docs.isEmpty) {
      debugPrint(
          '_deleteDirectSubCollectionDocuments : Aucun document trouvé dans $subCollectionName');
    } else {
      debugPrint(
          '_deleteDirectSubCollectionDocuments : Nombre de documents trouvés dans $subCollectionName: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        debugPrint(
            '_deleteDirectSubCollectionDocuments : Suppression du document: ${doc.id} dans $subCollectionName dans le batch');
        batch.delete(doc.reference);
      }
    }
  }

  Future<void> _deleteDocumentsInSubCollections(WriteBatch batch,
      DocumentReference parentDocRef, String subCollectionName) async {
    debugPrint(
        '_deleteDocumentsInSubCollections : Recherche de documents dans la sous-collection $subCollectionName avec collection_ref');
    QuerySnapshot snapshot = await _firebaseFirestore
        .collectionGroup(subCollectionName)
        .where('collection_ref', isEqualTo: parentDocRef)
        .get();

    if (snapshot.docs.isEmpty) {
      debugPrint(
          '_deleteDocumentsInSubCollections : Aucun document trouvé dans $subCollectionName avec collection_ref');
    } else {
      debugPrint(
          '_deleteDocumentsInSubCollections : Nombre de documents trouvés dans $subCollectionName avec collection_ref: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        debugPrint(
            '_deleteDocumentsInSubCollections : Suppression du document: ${doc.id} dans $subCollectionName avec collection_ref dans le batch');
        batch.delete(doc.reference);
      }
    }
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

  Future<List<Collection?>> getMyCollection({
    required String userId,
  }) async {
    const String functionName = 'getMyCollection';
    try {
      logger.logInfo(
          functionName,
          'Attempting to fetch collection references from Firestore...',
          {'userId': userId});

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

      logger.logInfo(
          functionName,
          'Collection references fetched. Fetching each collection document...',
          {'collectionRefsCount': collectionRefs.length});

      List<Future<Collection?>> futureCollections = collectionRefs.map(
        (ref) async {
          DocumentSnapshot collectionDoc = await ref.get();
          return Collection.fromDocument(collectionDoc);
        },
      ).toList();

      // Utiliser Future.wait pour résoudre toutes les collections
      List<Collection?> collections = await Future.wait(futureCollections);

      logger.logInfo(functionName, 'Collection objects created.',
          {'totalCollections': collections.length});

      if (collections.isNotEmpty) {
        logger.logInfo(functionName, 'First collection details',
            {'firstCollection': collections.first});
      }

      return collections;
    } catch (e) {
      logger.logError(
          functionName,
          'An error occurred while fetching collections',
          {'error': e.toString()});
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

  Future<bool> isPostInCollection({
    required String postId,
    required String collectionId,
    required String userIdfromPost,
  }) async {
    const String functionName = 'isPostInCollection';
    logger.logInfo(
        functionName, 'Attempting to check post in collection from Firestore', {
      'postId': postId,
      'collectionId': collectionId,
    });

    try {
      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      // Requête pour trouver le post dans la sous-collection spécifique de la collection
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.collections)
          .doc(collectionId)
          .collection(
              'feed_collection') // Assurez-vous que c'est le bon nom de sous-collection
          .where('post_ref', isEqualTo: postRef)
          .get();

      // Vérifier si le post existe dans la sous-collection
      bool exists = querySnapshot.docs.isNotEmpty;
      logger.logInfo(functionName, 'Post exists in collection', {
        'postId': postId,
        'collectionId': collectionId,
        'exists': exists,
      });
      return exists;
    } catch (e) {
      logger.logError(functionName, 'Error checking post in collection', {
        'postId': postId,
        'collectionId': collectionId,
        'error': e.toString(),
      });
      return false; // Retourne false en cas d'erreur
    }
  }

  // Supprime le post dans collections et dans le champ whoCollected
  Future<void> deletePostRefFromCollection({
    required String postId,
    required String collectionId,
    required String userIdfromPost,
  }) async {
    const String functionName = 'deletePostRefFromCollection';
    try {
      logger.logInfo(
          functionName, 'Suppression du post_ref de la collection en cours', {
        'postId': postId,
        'collectionId': collectionId,
        'userIdfromPost': userIdfromPost,
      });

      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      // Recherchez la référence spécifique du post dans la sous-collection 'feed_collection' de la collection spécifiée
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(Paths.collections)
          .doc(collectionId)
          .collection('feed_collection') // Nom de la sous-collection
          .where('post_ref', isEqualTo: postRef)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Supprimez uniquement la première référence trouvée, car elle doit être unique
        DocumentReference feedCollectionRef = snapshot.docs.first.reference;
        await feedCollectionRef.delete();
        logger.logInfo(
            functionName, 'Post_ref supprimé de la collection avec succès', {
          'postId': postId,
          'collectionId': collectionId,
          'feedCollectionRefId': feedCollectionRef.id,
        });

        // Supprimer la référence dans whoCollected du post
        await postRef.update({
          'whoCollected.${feedCollectionRef.id}': FieldValue.delete(),
        });
        logger.logInfo(
            functionName, 'Référence supprimée de whoCollected avec succès', {
          'postId': postId,
          'feedCollectionRefId': feedCollectionRef.id,
        });
      } else {
        logger
            .logInfo(functionName, 'Aucun post_ref trouvé dans la collection', {
          'postId': postId,
          'collectionId': collectionId,
        });
      }
    } catch (e) {
      logger.logError(functionName,
          'Erreur lors de la suppression du post_ref de la collection', {
        'postId': postId,
        'collectionId': collectionId,
        'userIdfromPost': userIdfromPost,
        'error': e.toString(),
      });
      throw Exception(
          'Erreur lors de la suppression du post_ref de la collection');
    }
  }

  Future<bool> isPostInLikes(
      {required String postId,
      required String userIdfromPost,
      required String userIdfromAuth}) async {
    const String functionName = 'isPostInLikes';
    try {
      logger.logInfo(functionName, 'Checking if post is in likes for user', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth
      });

      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      bool result = querySnapshot.docs.isNotEmpty;
      logger.logInfo(functionName, 'Post is in likes check completed',
          {'postId': postId, 'result': result});

      return result;
    } catch (e) {
      logger.logError(functionName, 'Error checking post in likes for user', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
        'error': e.toString()
      });
      return false;
    }
  }

  Future<void> deletePostRefFromLikes(
      {required String postId,
      required String userIdfromPost,
      required String userIdfromAuth}) async {
    {
      logger.logInfo(
          'deletePostRefFromLikes', 'Suppression du post des likes...', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      // Construire la référence correcte du post
      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      // Récupérer les documents likes qui contiennent cette référence de post
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      // Si des documents sont trouvés, les supprimer
      if (snapshot.docs.isNotEmpty) {
        await Future.wait(snapshot.docs.map((doc) async {
          // Supprimer la référence dans whoLiked avant de supprimer le document
          await postRef.update({
            'whoLiked.${doc.id}': FieldValue.delete(),
          });
          await doc.reference.delete();
        }));

        logger.logInfo(
            'deletePostRefFromLikes', 'Post supprimé des likes avec succès.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      } else {
        logger.logInfo(
            'deletePostRefFromLikes', 'Aucun post trouvé dans les likes.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      }
    }
  }
}
