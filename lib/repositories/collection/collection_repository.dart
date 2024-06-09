import 'package:bootdv2/config/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:flutter/material.dart';

class CollectionRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  CollectionRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('CollectionRepository');

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
}
