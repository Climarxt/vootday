import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'createcollection_state.dart';

class CreateCollectionCubit extends Cubit<CreateCollectionState> {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger _logger;

  CreateCollectionCubit({
    required FirebaseFirestore firebaseFirestore,
    required String widgetName,
  })  : _firebaseFirestore = firebaseFirestore,
        _logger = ContextualLogger(widgetName),
        super(CreateCollectionState.initial()) {
    _logger.logInfo('constructor', 'CreateCollectionCubit created');
  }

  Future<void> createCollection(
      String userId, String collectionTitle, bool public) async {
    emit(state.copyWith(status: CreateCollectionStatus.loading));

    try {
      _logger.logInfo(
        'createCollection',
        'Creating new collection...',
        {
          'userId': userId,
          'collectionTitle': collectionTitle,
          'public': public
        },
      );

      DateTime now = DateTime.now();

      final newCollection = Collection(
        id: '',
        author: User.empty.copyWith(id: userId),
        date: now,
        title: collectionTitle,
        public: public,
      );

      DocumentReference collectionRef = await _firebaseFirestore
          .collection('collections')
          .add(newCollection.toDocument());

      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('mycollection')
          .add({'collection_ref': collectionRef, 'date': now});

      _logger.logInfo(
        'createCollection',
        'Collection created successfully.',
        {'collectionRefId': collectionRef.id},
      );

      emit(state.copyWith(status: CreateCollectionStatus.success));
    } catch (e) {
      _logger.logError(
        'createCollection',
        'Error creating collection',
        {'error': e.toString()},
      );
      emit(state.copyWith(
        status: CreateCollectionStatus.error,
        failure: const Failure(
            message: 'Erreur lors de la création de la collection'),
      ));
    }
  }

  Future<String> createCollectionReturnCollectionId(
      String userId, String collectionTitle, bool public) async {
    emit(state.copyWith(status: CreateCollectionStatus.loading));

    try {
      _logger.logInfo(
        'createCollectionReturnCollectionId',
        'Creating new collection...',
        {
          'userId': userId,
          'collectionTitle': collectionTitle,
          'public': public
        },
      );

      DateTime now = DateTime.now();

      final newCollection = Collection(
        id: '',
        author: User.empty.copyWith(id: userId),
        date: now,
        title: collectionTitle,
        public: public,
      );

      DocumentReference collectionRef = await _firebaseFirestore
          .collection('collections')
          .add(newCollection.toDocument());

      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('mycollection')
          .add({'collection_ref': collectionRef, 'date': now});

      _logger.logInfo(
        'createCollectionReturnCollectionId',
        'Collection created successfully.',
        {'collectionRefId': collectionRef.id},
      );

      emit(state.copyWith(status: CreateCollectionStatus.success));
      return collectionRef.id;
    } catch (e) {
      _logger.logError(
        'createCollectionReturnCollectionId',
        'Error creating collection',
        {'error': e.toString()},
      );
      emit(state.copyWith(
        status: CreateCollectionStatus.error,
        failure: const Failure(
            message: 'Erreur lors de la création de la collection'),
      ));
      return '';
    }
  }
}
