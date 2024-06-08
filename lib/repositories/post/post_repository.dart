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
  Future<void> createPost(
      {required Post post,
      required String userId,
      required DateTime dateTime}) async {
    const String functionName = 'createPost';
    try {
      // Log début création de post
      logger.logInfo(functionName, 'Creating post for user', {
        'userId': userId,
        'postId': post.id,
        'dateTime': dateTime.toIso8601String(),
      });

      // Créer le post dans la collection personnelle de l'utilisateur
      final userPostRef = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.posts)
          .add({
        ...post.toDocument(),
        'date': dateTime,
      });

      // Log post créé dans la collection personnelle de l'utilisateur
      logger.logInfo(functionName, 'Post created in user collection', {
        'userPostRef': userPostRef.id,
        'userId': userId,
      });

      // Construire le chemin pour la référence du post
      String genderPath =
          post.selectedGender == 'Masculin' ? 'posts_man' : 'posts_woman';
      String locationPath = _getLocationPath(post);

      // Créer un document avec une référence du post
      final locationPostRef = await _firebaseFirestore
          .collection('$genderPath/$locationPath/posts')
          .add({
        'post_ref': userPostRef,
        'date': dateTime,
      });

      // Log référence de l'emplacement créé
      logger.logInfo(functionName, 'Location post reference created', {
        'locationPostRef': locationPostRef.id,
        'genderPath': genderPath,
        'locationPath': locationPath,
      });

      // Mettre à jour le post avec la référence de l'emplacement
      await userPostRef.update({'postReference': locationPostRef});

      // Log mise à jour de la référence de l'emplacement dans le post
      logger.logInfo(functionName, 'Post reference updated in user post', {
        'userPostRef': userPostRef.id,
        'locationPostRef': locationPostRef.id,
      });
    } catch (e) {
      // Log erreur durant la création du post
      logger.logError(functionName, 'Error creating post for user', {
        'userId': userId,
        'postId': post.id,
        'dateTime': dateTime.toIso8601String(),
        'error': e.toString(),
      });
    }
  }

  String _getLocationPath(Post post) {
    if (post.locationSelected == post.locationCountry) {
      return post.locationCountry;
    } else if (post.locationSelected == post.locationState) {
      return '${post.locationCountry}/regions/${post.locationState}';
    } else if (post.locationSelected == post.locationCity) {
      return '${post.locationCountry}/regions/${post.locationState}/cities/${post.locationCity}';
    } else {
      throw Exception('Invalid location selected');
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
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .collection(Paths.posts)
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

  Future<Post?> getPostById(String postId, String userId) async {
    try {
      DocumentSnapshot postSnap = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.posts)
          .doc(postId)
          .get();

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
