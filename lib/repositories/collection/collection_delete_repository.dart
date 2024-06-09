import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/config/configs.dart';

class CollectionDeleteRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  CollectionDeleteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('CollectionDeleteRepository');

  Future<void> deleteCollection({required String collectionId}) async {
    const String functionName = 'deleteCollection';
    WriteBatch batch = _firebaseFirestore.batch();
    logger.logInfo(
        functionName,
        'Début de la suppression de la collection avec ID:',
        {'collectionId': collectionId});

    DocumentReference collectionRef =
        _firebaseFirestore.collection(Paths.collections).doc(collectionId);

    // Suppression des documents dans la sous-collection 'mycollection'
    await _deleteDocumentsInSubCollections(
        batch, collectionRef, 'mycollection');

    // Suppression des documents dans la sous-collection directe 'feed_collection'
    await _deleteDirectSubCollectionDocuments(
        batch, collectionRef, 'feed_collection');

    logger.logInfo(
        functionName,
        'Suppression de la collection dans la collection collections',
        {'collectionId': collectionId});
    batch.delete(collectionRef);

    // Exécution du batch pour effectuer toutes les suppressions
    logger.logInfo(
        functionName,
        'Exécution du batch pour la suppression de la collection et des références associées',
        {'collectionId': collectionId});
    await batch.commit();
    logger.logInfo(
        functionName,
        'Suppression terminée pour la collection avec ID:',
        {'collectionId': collectionId});
  }

  Future<void> _deleteDirectSubCollectionDocuments(WriteBatch batch,
      DocumentReference parentDocRef, String subCollectionName) async {
    const String functionName = '_deleteDirectSubCollectionDocuments';
    logger.logInfo(
        functionName,
        'Recherche de documents dans la sous-collection',
        {'subCollectionName': subCollectionName});
    QuerySnapshot snapshot =
        await parentDocRef.collection(subCollectionName).get();

    if (snapshot.docs.isEmpty) {
      logger.logInfo(functionName, 'Aucun document trouvé dans',
          {'subCollectionName': subCollectionName});
    } else {
      logger.logInfo(functionName, 'Nombre de documents trouvés dans', {
        'subCollectionName': subCollectionName,
        'count': snapshot.docs.length
      });
      for (var doc in snapshot.docs) {
        logger.logInfo(functionName, 'Suppression du document dans le batch',
            {'docId': doc.id, 'subCollectionName': subCollectionName});
        batch.delete(doc.reference);
      }
    }
  }

  Future<void> _deleteDocumentsInSubCollections(WriteBatch batch,
      DocumentReference parentDocRef, String subCollectionName) async {
    const String functionName = '_deleteDocumentsInSubCollections';
    logger.logInfo(
        functionName,
        'Recherche de documents dans la sous-collection avec collection_ref',
        {'subCollectionName': subCollectionName});
    QuerySnapshot snapshot = await _firebaseFirestore
        .collectionGroup(subCollectionName)
        .where('collection_ref', isEqualTo: parentDocRef)
        .get();

    if (snapshot.docs.isEmpty) {
      logger.logInfo(functionName, 'Aucun document trouvé dans',
          {'subCollectionName': subCollectionName});
    } else {
      logger.logInfo(functionName,
          'Nombre de documents trouvés dans avec collection_ref', {
        'subCollectionName': subCollectionName,
        'count': snapshot.docs.length
      });
      for (var doc in snapshot.docs) {
        logger.logInfo(functionName, 'Suppression du document dans le batch',
            {'docId': doc.id, 'subCollectionName': subCollectionName});
        batch.delete(doc.reference);
      }
    }
  }
}
