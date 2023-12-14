import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'createcollection_state.dart';

class CreateCollectionCubit extends Cubit<CreateCollectionState> {
  final FirebaseFirestore _firebaseFirestore;

  CreateCollectionCubit({
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        super(CreateCollectionState.initial()) {
    debugPrint('CreateCollectionCubit created');
  }

  Future<void> createCollection(String userId, String collectionTitle) async {
    emit(state.copyWith(status: CreateCollectionStatus.loading));

    try {
      debugPrint('Method createCollection : Creating new collection...');

      DateTime now = DateTime.now(); // Capture de la date actuelle

      // Création de la nouvelle collection
      final newCollection = Collection(
        id: '', // Firestore générera un ID unique
        author: User.empty
            .copyWith(id: userId), // Mettre à jour avec l'utilisateur actuel
        date: now, // Utilisation de la date actuelle
        title: collectionTitle,
      );

      DocumentReference collectionRef = await _firebaseFirestore
          .collection('collections')
          .add(newCollection.toDocument());

      // Ajout de la référence de la collection et de la date à la sous-collection de l'utilisateur
      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('mycollection')
          .add({
        'collection_ref': collectionRef,
        'date': now // Ajout de la date ici
      });

      debugPrint('Method createCollection : Collection created successfully.');

      emit(state.copyWith(status: CreateCollectionStatus.success));
    } catch (e) {
      debugPrint(
          'Method createCollection : Error creating collection: ${e.toString()}');
      emit(state.copyWith(
        status: CreateCollectionStatus.error,
        failure:
            Failure(message: 'Erreur lors de la création de la collection'),
      ));
    }
  }
}
